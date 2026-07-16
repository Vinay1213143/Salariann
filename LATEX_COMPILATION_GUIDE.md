# SALARIANN PROJECT REPORT - LATEX COMPILATION GUIDE

## Overview

Your complete academic project report for Salariann has been generated in **3 LaTeX files** that can be compiled independently or combined into a single PDF document. Each file contains 2-3 chapters and is approximately 20-25 pages when compiled.

---

## Files Generated

| File | Chapters | Content |
|------|----------|---------|
| **SALARIANN_REPORT_PART1.tex** | 1-2 | Introduction, Literature Survey |
| **SALARIANN_REPORT_PART2.tex** | 3-4 | Proposed System, System Design |
| **SALARIANN_REPORT_PART3.tex** | 5-8 + Appendices | Technology, Implementation, Results, Conclusion, References, Appendices |

---

## Quick Start - Compile Individual Parts

### macOS / Linux

```bash
# Compile Part 1
pdflatex SALARIANN_REPORT_PART1.tex
pdflatex SALARIANN_REPORT_PART1.tex  # Run twice for TOC

# Compile Part 2
pdflatex SALARIANN_REPORT_PART2.tex
pdflatex SALARIANN_REPORT_PART2.tex

# Compile Part 3
pdflatex SALARIANN_REPORT_PART3.tex
pdflatex SALARIANN_REPORT_PART3.tex
```

### Windows (Command Prompt)

```cmd
pdflatex SALARIANN_REPORT_PART1.tex
pdflatex SALARIANN_REPORT_PART1.tex

pdflatex SALARIANN_REPORT_PART2.tex
pdflatex SALARIANN_REPORT_PART2.tex

pdflatex SALARIANN_REPORT_PART3.tex
pdflatex SALARIANN_REPORT_PART3.tex
```

---

## Installation Requirements

### macOS

```bash
# Install MacTeX (includes pdflatex)
brew install mactex

# Or download from: https://tug.org/mactex/
```

### Ubuntu/Debian

```bash
sudo apt-get update
sudo apt-get install texlive-full
```

### Windows

Download and install MiKTeX from: https://miktex.org/download

Or use TeX Live: https://www.tug.org/texlive/

---

## Compilation Methods

### Method 1: Using pdflatex (Recommended)

**Simplest and fastest method:**

```bash
cd /Users/bhaveshtayade/Desktop/salariann

# Compile each part
pdflatex SALARIANN_REPORT_PART1.tex
pdflatex SALARIANN_REPORT_PART1.tex  # Run twice for TOC

pdflatex SALARIANN_REPORT_PART2.tex
pdflatex SALARIANN_REPORT_PART2.tex

pdflatex SALARIANN_REPORT_PART3.tex
pdflatex SALARIANN_REPORT_PART3.tex
```

**Output files:**
- `SALARIANN_REPORT_PART1.pdf` (~25 pages)
- `SALARIANN_REPORT_PART2.pdf` (~25 pages)
- `SALARIANN_REPORT_PART3.pdf` (~30 pages)

### Method 2: Using xelatex (Better Unicode Support)

```bash
xelatex SALARIANN_REPORT_PART1.tex
xelatex SALARIANN_REPORT_PART1.tex

xelatex SALARIANN_REPORT_PART2.tex
xelatex SALARIANN_REPORT_PART2.tex

xelatex SALARIANN_REPORT_PART3.tex
xelatex SALARIANN_REPORT_PART3.tex
```

### Method 3: Using latexmk (Automatic Compilation)

```bash
# Install latexmk (usually comes with TeX distributions)

latexmk -pdf SALARIANN_REPORT_PART1.tex
latexmk -pdf SALARIANN_REPORT_PART2.tex
latexmk -pdf SALARIANN_REPORT_PART3.tex

# Clean up auxiliary files
latexmk -c
```

### Method 4: Using Online LaTeX Editors

**No installation required:**

1. **Overleaf** (https://www.overleaf.com/)
   - Create new project
   - Upload `.tex` files
   - Click "Recompile"
   - Download PDF

2. **Papeeria** (https://papeeria.com/)
   - Similar to Overleaf
   - Free tier available

---

## Combining Parts into Single Document

### Option A: Using pdflatex with Master File

Create a file named `SALARIANN_COMPLETE_REPORT.tex`:

```latex
\documentclass[12pt,a4paper,oneside]{report}

\usepackage[utf-8]{inputenc}
\usepackage[english]{babel}
\usepackage[margin=1in,left=1.5in]{geometry}
\usepackage{times}
\usepackage{setspace}

\onehalfspacing

\begin{document}

\input{SALARIANN_REPORT_PART1.tex}
\input{SALARIANN_REPORT_PART2.tex}
\input{SALARIANN_REPORT_PART3.tex}

\end{document}
```

Then compile:
```bash
pdflatex SALARIANN_COMPLETE_REPORT.tex
pdflatex SALARIANN_COMPLETE_REPORT.tex
```

### Option B: Using pdftk (Merge PDFs)

```bash
# Install pdftk
brew install pdftk  # macOS
sudo apt-get install pdftk  # Ubuntu

# Merge PDFs
pdftk SALARIANN_REPORT_PART1.pdf SALARIANN_REPORT_PART2.pdf \
      SALARIANN_REPORT_PART3.pdf cat output SALARIANN_COMPLETE_REPORT.pdf
```

### Option C: Using ImageMagick

```bash
# Install ImageMagick
brew install imagemagick  # macOS

# Convert PDFs to images and merge
convert -density 150 SALARIANN_REPORT_PART*.pdf SALARIANN_COMPLETE_REPORT.pdf
```

---

## Troubleshooting

### Issue: "pdflatex: command not found"

**Solution**: Install TeX distribution
```bash
# macOS
brew install mactex

# Ubuntu
sudo apt-get install texlive-full

# Windows
Download from https://miktex.org/download
```

### Issue: "Package not found" errors

**Solution**: Update LaTeX packages
```bash
# macOS
sudo tlmgr update --all

# Ubuntu
sudo apt-get install texlive-fonts-recommended texlive-latex-extra
```

### Issue: Special characters (₹) not displaying

**Solution**: Use xelatex instead of pdflatex
```bash
xelatex SALARIANN_REPORT_PART1.tex
```

### Issue: Figures/Diagrams not rendering

**Solution**: Ensure TikZ package is installed
```bash
# macOS
sudo tlmgr install pgfplots

# Ubuntu
sudo apt-get install texlive-pictures
```

### Issue: References not appearing

**Solution**: Compile twice (for table of contents and references)
```bash
pdflatex SALARIANN_REPORT_PART1.tex
pdflatex SALARIANN_REPORT_PART1.tex
```

---

## Customization

### Change Author Name

Edit the beginning of each `.tex` file:

```latex
\author{
    Your Name\\
    Exam No: [Your Exam Number]\\
    ...
}
```

### Change College/University Name

```latex
\author{
    ...
    Department of Computer Engineering\\
    [Your College Name]\\
    Savitribai Phule Pune University\\
    ...
}
```

### Change Guide Name

```latex
UNDER THE GUIDANCE OF\\
\textbf{[Your Guide Name]}
```

### Modify Formatting

**Font size:**
```latex
\documentclass[14pt,a4paper,oneside]{report}  % Change 12pt to 14pt
```

**Line spacing:**
```latex
\doublespacing  % Instead of \onehalfspacing
```

**Margins:**
```latex
\usepackage[margin=1.25in,left=1.5in]{geometry}  % Adjust margins
```

---

## Output Quality

### High-Quality PDF (for Printing)

```bash
pdflatex -interaction=nonstopmode SALARIANN_REPORT_PART1.tex
```

### Optimize for Screen Viewing

```bash
gs -sDEVICE=pdfwrite -dCompatibilityLevel=1.4 \
   -dPDFSETTINGS=/ebook \
   -dNOPAUSE -dQUIET -dBATCH \
   -sOutputFile=SALARIANN_REPORT_PART1_optimized.pdf \
   SALARIANN_REPORT_PART1.pdf
```

---

## File Structure After Compilation

```
salariann/
├── SALARIANN_REPORT_PART1.tex
├── SALARIANN_REPORT_PART1.pdf          ← Generated
├── SALARIANN_REPORT_PART1.aux          ← Auxiliary
├── SALARIANN_REPORT_PART1.log          ← Log file
├── SALARIANN_REPORT_PART1.out          ← Outline
├── SALARIANN_REPORT_PART1.toc          ← Table of Contents
│
├── SALARIANN_REPORT_PART2.tex
├── SALARIANN_REPORT_PART2.pdf          ← Generated
├── SALARIANN_REPORT_PART2.aux
├── SALARIANN_REPORT_PART2.log
│
├── SALARIANN_REPORT_PART3.tex
├── SALARIANN_REPORT_PART3.pdf          ← Generated
├── SALARIANN_REPORT_PART3.aux
├── SALARIANN_REPORT_PART3.log
│
└── SALARIANN_COMPLETE_REPORT.pdf       ← Merged (optional)
```

---

## Cleaning Up Auxiliary Files

After compilation, you can delete auxiliary files to save space:

```bash
# macOS/Linux
rm *.aux *.log *.out *.toc *.lof *.lot

# Or use latexmk
latexmk -c
```

---

## Recommended Workflow

1. **Install TeX Distribution**
   ```bash
   brew install mactex  # macOS
   ```

2. **Navigate to Project Directory**
   ```bash
   cd /Users/bhaveshtayade/Desktop/salariann
   ```

3. **Compile Each Part**
   ```bash
   pdflatex SALARIANN_REPORT_PART1.tex
   pdflatex SALARIANN_REPORT_PART1.tex
   pdflatex SALARIANN_REPORT_PART2.tex
   pdflatex SALARIANN_REPORT_PART2.tex
   pdflatex SALARIANN_REPORT_PART3.tex
   pdflatex SALARIANN_REPORT_PART3.tex
   ```

4. **Verify PDFs Generated**
   ```bash
   ls -lh *.pdf
   ```

5. **Merge into Single Document** (Optional)
   ```bash
   pdftk SALARIANN_REPORT_PART*.pdf cat output SALARIANN_COMPLETE_REPORT.pdf
   ```

6. **Clean Up Auxiliary Files**
   ```bash
   latexmk -c
   ```

---

## Expected Output

After successful compilation, you will have:

- **Part 1 PDF**: ~25 pages (Chapters 1-2)
- **Part 2 PDF**: ~25 pages (Chapters 3-4)
- **Part 3 PDF**: ~30 pages (Chapters 5-8 + Appendices)
- **Complete PDF**: ~80 pages (All chapters combined)

**Total**: Approximately **80-100 pages** of professional academic report

---

## Verification Checklist

After compilation, verify:

- [ ] All 3 PDFs generated successfully
- [ ] Table of contents present and correct
- [ ] Page numbers sequential
- [ ] Figures and diagrams rendered properly
- [ ] Code listings formatted correctly
- [ ] Tables properly formatted
- [ ] References and citations present
- [ ] No compilation errors in log files
- [ ] PDF file sizes reasonable (5-15 MB each)

---

## Support Resources

- **LaTeX Documentation**: https://www.latex-project.org/
- **Overleaf Tutorials**: https://www.overleaf.com/learn
- **TeX Stack Exchange**: https://tex.stackexchange.com/
- **MiKTeX Documentation**: https://miktex.org/
- **MacTeX Documentation**: https://tug.org/mactex/

---

## Summary

Your LaTeX files are ready to compile! Follow these steps:

1. Install TeX distribution (if not already installed)
2. Run `pdflatex` on each `.tex` file twice
3. Merge PDFs using `pdftk` (optional)
4. Verify all pages and formatting
5. Submit your professional 80-100 page report!

---

**Status**: ✅ LaTeX files ready for compilation

**Estimated Compilation Time**: 2-3 minutes per file

**Final Output**: Professional PDF report (~80-100 pages)

---

*Salariann: Intelligent Job Search and Career Analysis Platform*  
*Complete Academic Project Report in LaTeX*  
*June 2024*
