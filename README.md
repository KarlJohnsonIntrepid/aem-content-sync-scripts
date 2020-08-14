# Quick AEM Content Sync

Quick AEM Content Sync is a set of curl commands for transfering aem content packages from one environment to your local aem instance.

This saves time connecting to remote instances, opening package manager to build content packages, downloading and then installing the package on your local aem instance.

Provide the connection details to the remote instance and the path your want to copy and it will do the following.

1. Create package on the remote instance
2. Add filter to the package on the remote instance
3. Build the package on remote instance
4. Download the package from the remote instance
5. Delete the package from the remote instance
6. Install and build the package on the local instance
7. Clean up downloaded package

## Usage

\*\* This has only been tested on windows using git bash

Execute script

sh curlPackageFilter.sh

Add required arguments in this order (all are required)

1. Username - e.g admin
2. Password - e.g admin
3. SiteUrl - e.g https://aem.site.com
4. Filter - e.g content/yoursite/page1
5. PackageName - mypackage

#### Example Command

sh curlPackageFilter.sh admin admin https://aem.site.com /content/pages pages

```

## Contributing
This is a tool to increase my personal productivity. Please feel free to fork the code and update yourself if you wish to make changes

## License
[MIT](https://choosealicense.com/licenses/mit/)
```
