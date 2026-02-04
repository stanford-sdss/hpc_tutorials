#!/bin/bash

echo "Setting up Geospatial Dask kernel..."

# Create the kernel directory
echo "Creating kernel directory..."
mkdir -p ~/.local/share/jupyter/kernels/geospatial-dask

# Create the kernel.json file
echo "Creating kernel.json file..."
cat > ~/.local/share/jupyter/kernels/geospatial-dask/kernel.json << 'EOF'
{
    "argv": [
        "apptainer", "exec", 
        "~/geospatial_dask.sif",
        "python", "-m", "ipykernel_launcher", "-f", "{connection_file}"
    ],
    "display_name": "Geospatial Dask (daskenv)",
    "language": "python"
}
EOF

echo "Kernel setup complete!"
echo "The 'Geospatial Dask' kernel should now be available in Jupyter Lab."
echo ""
echo "To verify, check that the directory exists:"
echo "ls -la ~/.local/share/jupyter/kernels/"