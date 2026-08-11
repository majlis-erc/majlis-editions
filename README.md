# MAJLIS-Editions

[![License](https://img.shields.io/badge/license-GPL%203.0%20only-blue.svg)](http://www.gnu.org/licenses/gpl-3.0.html)

An application for digital scholarly editions of Judeo-Arabic texts built atop [TEI Publisher 9](https://teipublisher.com/).

## Overview

MAJLIS-Editions builds on TEI Publisher to provide a reading environment tailored to the specific needs of Judeo-Arabic manuscript editions. The central design choice is **synchronized page-by-page navigation**: the original text, translation(s), and facsimile are displayed together for a single page at a time, and selecting any entry in the table of contents instantly jumps all views to the corresponding page.

## Features

- **Page-synchronized views** — original text, translation, and facsimile move together; no view falls out of sync
- **TOC-driven navigation** — clicking a section in the table of contents brings all panels to the relevant page
- **Facsimile integration** — manuscript images are displayed alongside text and translation
- **Built on TEI Publisher 9** — inherits full TEI XML processing, ODD customization, and the Elemental backend

## Differences from Standard TEI Publisher

Most TEI Publisher applications navigate by structural division (chapters, sections, etc.) and display content as a continuous flow. MAJLIS-Editions instead:

- Navigates by **physical page** (`<pb/>` elements) rather than by logical division
- Keeps multiple views **locked to the same page** at all times
- Treats the TOC as a page locator rather than a section loader

This makes it better suited to text–translation–image work where the manuscript page is the primary unit of reference.

## Building from Source Code

### Requirements

- [Elemental](https://elemental.xyz) 6.11.0
- [tei-publisher-lib](https://github.com/eeditiones/tei-publisher-lib) 4.0.4
- [roaster](https://github.com/eeditiones/roaster) 1.12.1
- Java 11 or newer
- [Maven](https://maven.apache.org/) 3.9 or newer


All of the above need to be installed and available on the system PATH.

### Build Instructions

1. Clone the repository if you have not previously done so and enter its directory:
```shell
$ git clone https://github.com/evolvedbinary/majlis-editions.git
$ cd majlis-editions
```

2. or, if you have previously cloned the repository, make sure it is up to date
```shell
$ cd majlis-editions
$ git pull
```

3. Build the source code with Maven:

```git
mvn clean package
```

The XAR file will be at `target/majlis-editions-0.1.0-SNAPSHOT.xar`.


## Installation Instructions
1. Make sure that the correct version of the tei-publisher-lib and roaster XAR files are already installed into Elemental.
2. Either build from source (see above) or download the XAR file from https://github.com/majlis-erc/majlis-editions/releases
3. Upload the XAR file and install it via the Dashboard's Package Manager.

## Docker

A Docker image is provided that bundles Elemental together with the MAJLIS Editions application.

### Build the Docker Image

Use the `docker` Maven profile to produce the image locally:

```shell
mvn package -P docker
```

### Run the Container Locally

```shell
docker run --rm \
  --name majlis-editions-test \
  -p 8080:8080 \
  -p 8443:8443 \
  majlis-erc/majlis-editions:latest
```

