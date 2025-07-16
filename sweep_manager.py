"""
Sweep Manager for Spice Simulation Orchestrator
Handles parameter sweeping, metadata generation, and workflow coordination
"""

import os
import yaml
import pandas as pd
import numpy as np
import itertools
from datetime import datetime
from typing import Dict, List, Any, Iterator, Tuple
import hashlib
import csv


class SweepManager:
    """Manages parameter sweeps for simulation testbenches"""
    
    def __init__(self, config_path: str, base_output_dir: str):
        """
        Initialize sweep manager
        
        Args:
            config_path: Path to config.yaml file
            base_output_dir: Base directory for simulation outputs
        """
        self.config_path = config_path
        self.base_output_dir = base_output_dir
        self.config = self._load_config()
        self.sweep_points = []
        self.metadata_df = None
        
    def _load_config(self) -> Dict[str, Any]:
        """Load and validate configuration"""
        with open(self.config_path, 'r') as f:
            config = yaml.safe_load(f)
        
        # Validate structure
        if 'parameters' not in config:
            raise ValueError("Missing 'parameters' section in config")
            
        return config
    
    def has_sweep(self) -> bool:
        """Check if configuration contains sweep definition"""
        return 'sweep' in self.config
    
    def generate_sweep_points(self) -> List[Dict[str, Any]]:
        """Generate all parameter combinations for sweep"""
        if not self.has_sweep():
            # Single point "sweep" - just return base parameters
            return [self.config['parameters'].copy()]
        
        sweep_config = self.config['sweep']
        base_params = self.config['parameters'].copy()
        
        # Generate parameter arrays for each sweep parameter
        param_arrays = {}
        for param_name, param_config in sweep_config['parameters'].items():
            param_arrays[param_name] = self._generate_parameter_array(param_config)
        
        # Generate all combinations
        param_names = list(param_arrays.keys())
        param_combinations = itertools.product(*param_arrays.values())
        
        sweep_points = []
        for i, param_values in enumerate(param_combinations):
            # Start with base parameters
            point_params = base_params.copy()
            
            # Override with sweep values
            for param_name, param_value in zip(param_names, param_values):
                point_params[param_name] = param_value
            
            # Generate unique sweep point ID
            sweep_id = self._generate_sweep_id(point_params, i)
            
            sweep_point = {
                'sweep_id': sweep_id,
                'sweep_index': i,
                'parameters': point_params,
                'netlist_path': os.path.join(self.base_output_dir, sweep_id, 'tb_netlist.spice'),
                'results_path': os.path.join(self.base_output_dir, sweep_id, point_params.get('output_file', 'results.raw')),
                'output_dir': os.path.join(self.base_output_dir, sweep_id),
                'timestamp': datetime.now().isoformat(),
                'status': 'pending'
            }
            
            sweep_points.append(sweep_point)
        
        self.sweep_points = sweep_points
        return sweep_points
    
    def _generate_parameter_array(self, param_config: Dict[str, Any]) -> np.ndarray:
        """Generate parameter array based on sweep configuration"""
        sweep_type = param_config.get('type', 'linear')
        
        if sweep_type == 'linear':
            return np.linspace(
                param_config['start'], 
                param_config['stop'], 
                param_config['steps']
            )
        elif sweep_type == 'log':
            return np.logspace(
                np.log10(param_config['start']),
                np.log10(param_config['stop']),
                param_config['steps']
            )
        elif sweep_type == 'list':
            return np.array(param_config['values'])
        else:
            raise ValueError(f"Unknown sweep type: {sweep_type}")
    
    def _generate_sweep_id(self, parameters: Dict[str, Any], index: int) -> str:
        """Generate unique ID for sweep point"""
        # Create a hash of the parameters for uniqueness
        param_str = str(sorted(parameters.items()))
        param_hash = hashlib.md5(param_str.encode()).hexdigest()[:8]
        return f"sweep_{index:04d}_{param_hash}"
    
    def generate_metadata_csv(self, output_path: str = None) -> pd.DataFrame:
        """Generate metadata DataFrame and optionally save to CSV"""
        if not self.sweep_points:
            raise ValueError("No sweep points generated. Call generate_sweep_points() first.")
        
        # Flatten sweep points into metadata records
        metadata_records = []
        for point in self.sweep_points:
            record = {
                'sweep_id': point['sweep_id'],
                'sweep_index': point['sweep_index'],
                'netlist_path': point['netlist_path'],
                'results_path': point['results_path'],
                'output_dir': point['output_dir'],
                'timestamp': point['timestamp'],
                'status': point['status']
            }
            
            # Add parameter values as columns
            for param_name, param_value in point['parameters'].items():
                record[f'param_{param_name}'] = param_value
            
            metadata_records.append(record)
        
        # Create DataFrame
        self.metadata_df = pd.DataFrame(metadata_records)
        
        # Save to CSV if path provided
        if output_path:
            self.metadata_df.to_csv(output_path, index=False)
            print(f"Metadata saved to: {output_path}")
        
        return self.metadata_df
    
    def update_sweep_status(self, sweep_id: str, status: str, error_msg: str = None):
        """Update status of a sweep point"""
        for point in self.sweep_points:
            if point['sweep_id'] == sweep_id:
                point['status'] = status
                if error_msg:
                    point['error_msg'] = error_msg
                break
        
        # Update DataFrame if it exists
        if self.metadata_df is not None:
            mask = self.metadata_df['sweep_id'] == sweep_id
            self.metadata_df.loc[mask, 'status'] = status
            if error_msg:
                self.metadata_df.loc[mask, 'error_msg'] = error_msg
    
    def get_sweep_summary(self) -> Dict[str, Any]:
        """Get summary statistics of the sweep"""
        if not self.sweep_points:
            return {}
        
        total_points = len(self.sweep_points)
        status_counts = {}
        
        for point in self.sweep_points:
            status = point['status']
            status_counts[status] = status_counts.get(status, 0) + 1
        
        return {
            'total_points': total_points,
            'status_counts': status_counts,
            'sweep_parameters': list(self.config.get('sweep', {}).get('parameters', {}).keys()) if self.has_sweep() else []
        }
    
    def get_failed_points(self) -> List[Dict[str, Any]]:
        """Get list of failed sweep points"""
        return [point for point in self.sweep_points if point['status'] == 'failed']
    
    def get_completed_points(self) -> List[Dict[str, Any]]:
        """Get list of completed sweep points"""
        return [point for point in self.sweep_points if point['status'] == 'completed']


# Utility functions for post-processing
def load_sweep_metadata(csv_path: str) -> pd.DataFrame:
    """Load sweep metadata from CSV file"""
    return pd.read_csv(csv_path)

def filter_successful_sweeps(df: pd.DataFrame) -> pd.DataFrame:
    """Filter DataFrame to only include successful simulation runs"""
    return df[df['status'] == 'completed']

def group_by_parameter(df: pd.DataFrame, param_name: str) -> pd.DataFrameGroupBy:
    """Group sweep results by a specific parameter"""
    param_col = f'param_{param_name}'
    if param_col not in df.columns:
        raise ValueError(f"Parameter '{param_name}' not found in metadata")
    return df.groupby(param_col)

def extract_parameter_columns(df: pd.DataFrame) -> List[str]:
    """Extract all parameter column names from metadata DataFrame"""
    return [col for col in df.columns if col.startswith('param_')]

def create_parameter_summary(df: pd.DataFrame) -> pd.DataFrame:
    """Create summary statistics for all parameters"""
    param_cols = extract_parameter_columns(df)
    summary_data = []
    
    for col in param_cols:
        param_name = col.replace('param_', '')
        values = df[col]
        
        summary_data.append({
            'parameter': param_name,
            'min': values.min(),
            'max': values.max(),
            'mean': values.mean() if values.dtype in ['float64', 'int64'] else None,
            'unique_values': len(values.unique()),
            'total_points': len(values)
        })
    
    return pd.DataFrame(summary_data)