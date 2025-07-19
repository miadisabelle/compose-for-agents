# Audio Pipeline Toolkit - Examples

This directory contains three practical examples demonstrating different use cases for the audio pipeline toolkit.

## Examples Overview

### Example 1: Basic Conversion (`example1_basic_conversion.sh`)
- **Purpose**: Simple WAV to MP3 conversion with metadata
- **Use case**: Converting single files with custom metadata
- **Features**: Command-line arguments, custom bitrate
- **Requirements**: Place a WAV file named `input_demo.wav` in this directory

### Example 2: Environment-based Batch Processing (`example2_env_batch.sh`)
- **Purpose**: Process multiple files using environment variables
- **Use case**: Batch processing with consistent metadata (podcasts, albums)
- **Features**: .env file configuration, automatic file detection
- **Requirements**: Place WAV files in this directory

### Example 3: Quality Variants (`example3_quality_variants.sh`)
- **Purpose**: Create multiple quality versions of the same audio
- **Use case**: Generating different bitrate versions for distribution
- **Features**: High/Medium/Low quality outputs, comparative metadata
- **Requirements**: Place a WAV file named `source_audio.wav` in this directory

## Running Examples

1. Make sure you have the dependencies installed:
   ```bash
   cd ..
   pip install -r requirements.txt
   ```

2. Navigate to the examples directory:
   ```bash
   cd examples
   ```

3. Run any example:
   ```bash
   ./example1_basic_conversion.sh
   ./example2_env_batch.sh  
   ./example3_quality_variants.sh
   ```

## Notes
- All examples are self-contained and include usage instructions
- Example scripts will indicate if required input files are missing
- Generated output files will be created in the examples directory