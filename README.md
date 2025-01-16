
![SpaSES_Logo](https://github.com/user-attachments/assets/1b41df1c-47c8-480e-92b1-c4dc5fc4571e)

# Project Repository Template

Welcome to the SpaSES Lab project repository template! This repository is designed to help organize your project with standardized practices for managing code, data, and metadata. The following sections provide instructions on how to effectively use this repository template.

## Table of Contents
1. [How to Use This Repository](#how-to-use-this-repository)
2. [Filling Out the Metadata Template - NEEDS EDITING](#filling-out-the-metadata-template)
3. [Downloading and Uploading Data to/from SpaSES Google Drive](#downloading-and-uploading-data-tofrom-spases-google-drive)
4. [Standards for Documenting Code - NEEDS EDITING](#standards-for-documenting-code)
5. [Committing, Pushing, and Pulling Changes](#committing-pushing-and-pulling-changes)
6. [Using `.gitignore` - NEEDS EDITING](#using-gitignore)
7. [`README.md` File Guidelines](#readmemd-file-guidelines)

---

## How to Use This Repository

This repository serves as a template for managing your project and collaborating with others in the SpaSES Lab. It provides:

- A consistent file structure for storing code, data, and metadata.
- Templates for downloading and uploading project data from/to the SpaSES Google Drive.
- Guidelines for documenting your code, managing version control, and maintaining a well-organized project.

To use this repository, you can either:
- Clone it directly for a new project or
- Fork it to create a personal copy for customization.

Once you’ve cloned or forked the repository, follow the instructions in each section to properly set up and maintain your project.

---

## Filling Out the Metadata Template

The metadata template is essential for documenting key project information. It helps to standardize metadata for easier sharing, querying, and organizing your project files. To fill out the metadata template:

1. Open the metadata template file (`project_metadata.R`) found in the `metadata_info/` directory.
2. Review the fields provided and fill in the necessary details such as:
4. Add any other project-specific metadata as needed.
5. Save your completed metadata file in the `metadata_info/metadata/` directory of your project.

#### Ensure that the metadata is kept up to date as the project progresses.

---

## Downloading and Uploading Data to/from SpaSES Google Drive

This repository includes templates for downloading and uploading data from/to the SpaSES Google Drive. For both downloading and uploading, ensure you have the necessary permissions to access the Google Drive folder. Here’s how to use the provided templates:

### 1. Downloading Data from SpaSES Google Drive

To download project data from the SpaSES Google Drive to your local R environment, you can use the provided script `download_data.R` found in the `data/utilities/` directory. Follow these steps:

- Open the `download_data.R` script.
- Replace the `folder_id` variable with your appropriate project folder ID located in the SpaSES Lab Google Drive (further details can be found in the `download_data.R` script).
- Run the script to authenticate and download the files into your local project directory.

### 2. Uploading Data to SpaSES Google Drive

To upload data from your local R environment to the SpaSES Google Drive, use the provided script `upload_data.R` found in the `data/utilities/` directory. Here’s how:

1. Open the `upload_data.R` script.
2. Replace the `folder_id` variable with your appropriate project folder ID located in the SpaSES Lab Google Drive (further details can be found in the `upload_data.R` script).
3. Specify the local files to upload by adjusting the file paths in the script.
4. Run the script to authenticate and upload the files to the designated project folder.

---

## Standards for Documenting Code

Writing clear, readable, and well-documented code is essential for collaboration and long-term project sustainability. Follow these best practices for documenting your code:

### Commenting Code
- Use comments to explain the purpose of functions, key steps, and non-obvious logic.
- Use inline comments to clarify specific lines of code where needed.
- Keep comments concise but descriptive.

### File, Function, and Variable Naming - Insert more information on file and variable naming standards
- Use meaningful names that clearly describe the purpose of the function or variable.
- Follow a consistent naming convention (e.g., `camelCase`, `snake_case`) throughout your scripts.

### Script Organization - Insert more information on when to use multiple scripts or files
- Organize scripts into sections using clear comments (e.g., `### Data Cleaning`, `### Data Analysis`).
- Consider separating large scripts into smaller, modular functions or scripts based on functionality.

### Code Formatting (Style Guide) - Insert more information for using the `lintr` and `styler` packages
- Maintain consistent indentation (e.g., 2 spaces or 4 spaces per indent).
- Ensure there’s a consistent style for brackets, spaces, and operators.

### Documentation Tools - More information needed here
- Use R Markdown or similar tools for documenting analyses that require detailed explanations and results.

### Managing Dependencies with `packages.R`
- A script template called `packages.R` is included in the repository for managing required packages.
- Use `packages.R` to install all the necessary packages for running your scripts. Add or remove package installation commands as needed for your project.
- To load packages, use `library()` calls in your individual scripts to load all required packages at the very beginning of each file. This ensures that dependencies are loaded before executing the rest of the code.

---

## Committing, Pushing, and Pulling Changes

Effective version control is essential for tracking changes, collaborating with others, and ensuring your project evolves in an organized manner. Follow these GitHub best practices:

### Committing Changes
- Commit your changes regularly with clear, descriptive commit messages.
- Each commit should represent a logical unit of work, such as a completed feature or a fixed bug.
- Example:
```r
git commit -m "Added function for data cleaning"
```

### Pushing Changes:
- Push your changes to the remote repository after committing them locally.
- Example:
```r
git push origin main
```

### Pulling Changes:
- Before starting work each day, pull the latest changes from the main branch to keep your local repository up to date.
- Example: 
```r
git pull origin main
```

### Branching:
- Use branches to develop new features or fix bugs. Once a branch is complete, merge it back into the main branch.

---

## Using `.gitignore`
- Add Information (currently the data and metadata folder is in .gitignore, but should still show up with the use of .gitkeep)

---

## `README.md` File Guidelines
A good `README.md` file is essential for explaining the purpose of the project, how to use it, and providing instructions for others who may be working with the repository. Here are the key components to include:

### Project Title and Description:
- Provide a clear title and description of the project’s goals and objectives.

### Installation Instructions:
- Explain how to set up the project environment, including necessary dependencies and tools (e.g., R packages, external software).

### Usage Instructions:
- Provide clear examples of how to use the scripts, templates, or functions included in the repository.

### Contributing:
- If you are open to contributions, provide guidelines for contributing to the project.

### License Information:
- Include licensing information to indicate how others can use and modify the project.

### Contact Information:
- Provide information on how to contact the project maintainers for questions or issues.

#### Remember, a well-structured `README.md` improves the usability and collaboration potential of the repository!

---
