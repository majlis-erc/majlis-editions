# MAJLIS-Editions

A [TEI Publisher 9](https://teipublisher.com/) application for digital scholarly editions of Judeo-Arabic texts.

## Overview

MAJLIS-Editions builds on TEI Publisher to provide a reading environment tailored to the specific needs of Judeo-Arabic manuscript editions. The central design choice is **synchronized page-by-page navigation**: the original text, translation(s), and facsimile are displayed together for a single page at a time, and selecting any entry in the table of contents instantly jumps all views to the corresponding page.

## Features

- **Page-synchronized views** — original text, translation, and facsimile move together; no view falls out of sync
- **TOC-driven navigation** — clicking a section in the table of contents brings all panels to the relevant page
- **Facsimile integration** — manuscript images are displayed alongside text and translation
- **Built on TEI Publisher 9** — inherits full TEI XML processing, ODD customization, and the eXist-db backend

## Differences from Standard TEI Publisher

Most TEI Publisher applications navigate by structural division (chapters, sections, etc.) and display content as a continuous flow. MAJLIS-Editions instead:

- Navigates by **physical page** (`<pb/>` elements) rather than by logical division
- Keeps multiple views **locked to the same page** at all times
- Treats the TOC as a page locator rather than a section loader

This makes it better suited to text–translation–image work where the manuscript page is the primary unit of reference.

## Requirements

- [eXist-db](https://exist-db.org/) 6.2
- TEI Publisher 9

## Installation

1. Download the code to your computer.
2. Generate a .xar file.
3. Upload and install it via the eXist-db Package Manager.
4. TEI Publisher 9 must already be installed as a dependency.

## License

[MIT](LICENSE) — TEI Publisher itself is licensed under LGPL.
