# SALARIANN LATEX REPORT - COMPILATION INSTRUCTIONS

## Quick Compilation (One Command)

Run this single command to compile all three parts and merge them into one PDF:

```bash
cd /Users/bhaveshtayade/Desktop/salariann && \
pdflatex SALARIANN_REPORT_PART1.tex && pdflatex SALARIANN_REPORT_PART1.tex && \
pdflatex SALARIANN_REPORT_PART2.tex && pdflatex SALARIANN_REPORT_PART2.tex && \
pdflatex SALARIANN_REPORT_PART3.tex && pdflatex SALARIANN_REPORT_PART3.tex && \
pdftk SALARIANN_REPORT_PART1.pdf SALARIANN_REPORT_PART2.pdf SALARIANN_REPORT_PART3.pdf cat output SALARIANN_COMPLETE_REPORT.pdf && \
echo "✅ Done! Your complete report is ready: SALARIANN_COMPLETE_REPORT.pdf"
```

---

## Step-by-Step Compilation

### Step 1: Compile Part 1 (Chapters 1-2)
```bash
cd /Users/bhaveshtayade/Desktop/salariann
pdflatex SALARIANN_REPORT_PART1.tex
pdflatex SALARIANN_REPORT_PART1.tex
```
**Output**: `SALARIANN_REPORT_PART1.pdf` (~25 pages)

### Step 2: Compile Part 2 (Chapters 3-4)
```bash
pdflatex SALARIANN_REPORT_PART2.tex
pdflatex SALARIANN_REPORT_PART2.tex
```
**Output**: `SALARIANN_REPORT_PART2.pdf` (~25 pages)

### Step 3: Compile Part 3 (Chapters 5-8 + Appendices)
```bash
pdflatex SALARIANN_REPORT_PART3.tex
pdflatex SALARIANN_REPORT_PART3.tex
```
**Output**: `SALARIANN_REPORT_PART3.pdf` (~30 pages)

### Step 4: Merge All PDFs into One
```bash
pdftk SALARIANN_REPORT_PART1.pdf SALARIANN_REPORT_PART2.pdf SALARIANN_REPORT_PART3.pdf cat output SALARIANN_COMPLETE_REPORT.pdf
```
**Output**: `SALARIANN_COMPLETE_REPORT.pdf` (~80-100 pages)

---

## Why Run pdflatex Twice?

LaTeX requires two compilation passes to:
1. Generate the table of contents
2. Generate cross-references and page numbers
3. Update the bibliography

The first pass creates temporary files (`.aux`, `.toc`, `.lof`, `.lot`), and the second pass uses these to create the final PDF with correct numbering.

---

## Installation Requirements

### macOS
```bash
brew install mactex
```

### Ubuntu/Debian
```bash
sudo apt-get install texlive-full
```

### Windows
Download from: https://miktex.org/download

---

## Troubleshooting

### Issue: "pdflatex: command not found"
**Solution**: Install TeX distribution (see Installation Requirements above)

### Issue: "Package not found" errors
**Solution**: Update LaTeX packages
```bash
sudo tlmgr update --all  # macOS
sudo apt-get install texlive-fonts-recommended texlive-latex-extra  # Ubuntu
```

### Issue: Special characters (₹) not displaying
**Solution**: Use xelatex instead
```bash
xelatex SALARIANN_REPORT_PART1.tex
xelatex SALARIANN_REPORT_PART1.tex
```

### Issue: pdftk not found
**Solution**: Install pdftk
```bash
brew install pdftk  # macOS
sudo apt-get install pdftk  # Ubuntu
```

---

## Alternative: Compile Without Merging

If you prefer to keep the three PDFs separate:

```bash
cd /Users/bhaveshtayade/Desktop/salariann
pdflatex SALARIANN_REPORT_PART1.tex && pdflatex SALARIANN_REPORT_PART1.tex
pdflatex SALARIANN_REPORT_PART2.tex && pdflatex SALARIANN_REPORT_PART2.tex
pdflatex SALARIANN_REPORT_PART3.tex && pdflatex SALARIANN_REPORT_PART3.tex
```

This creates:
- `SALARIANN_REPORT_PART1.pdf`
- `SALARIANN_REPORT_PART2.pdf`
- `SALARIANN_REPORT_PART3.pdf`

---

## Files Generated After Compilation

```
/Users/bhaveshtayade/Desktop/salariann/
├── SALARIANN_REPORT_PART1.pdf          (25 pages)
├── SALARIANN_REPORT_PART2.pdf          (25 pages)
├── SALARIANN_REPORT_PART3.pdf          (30 pages)
├── SALARIANN_COMPLETE_REPORT.pdf       (80-100 pages) ← FINAL REPORT
│
├── SALARIANN_REPORT_PART1.aux          (auxiliary files)
├── SALARIANN_REPORT_PART1.log          (log files)
├── SALARIANN_REPORT_PART1.toc          (table of contents)
├── SALARIANN_REPORT_PART1.lof          (list of figures)
├── SALARIANN_REPORT_PART1.lot          (list of tables)
│
└── ... (similar auxiliary files for PART2 and PART3)
```

---

## Clean Up Auxiliary Files

After successful compilation, remove auxiliary files to save space:

```bash
cd /Users/bhaveshtayade/Desktop/salariann
rm *.aux *.log *.out *.toc *.lof *.lot *.fls *.fdb_latexmk
```

Or use latexmk:
```bash
latexmk -c
```

---

## Verification Checklist

After compilation, verify:

- [ ] All 3 PDFs generated successfully
- [ ] No error messages in terminal
- [ ] Table of contents present and correct
- [ ] Page numbers sequential
- [ ] Figures and diagrams rendered properly
- [ ] Code listings formatted correctly
- [ ] Tables properly formatted
- [ ] References and citations present
- [ ] Final merged PDF is ~80-100 pages

---

## Expected Output

**SALARIANN_COMPLETE_REPORT.pdf** should contain:

✅ Front Matter (Title, Certificate, Acknowledgement, Abstract, TOC, LOF, LOT)  
✅ Chapter 1: Introduction  
✅ Chapter 2: Literature Survey  
✅ Chapter 3: Proposed System  
✅ Chapter 4: System Design  
✅ Chapter 5: Technology and Tools Overview  
✅ Chapter 6: System Implementation  
✅ Chapter 7: Result and Performance Analysis  
✅ Chapter 8: Conclusion and Future Work  
✅ References  
✅ Appendix A: System API Documentation  
✅ Appendix B: Database Schema Definitions  

**Total**: ~80-100 professional academic pages

---

## Customization

Before compilation, edit the author details in each `.tex` file:

```latex
\author{
    Your Name\\
    Exam No: [Your Exam Number]\\
    \vspace{0.5cm}
    Under the Guidance of\\
    [Your Guide Name]\\
    \vspace{0.5cm}
    Department of Computer Engineering\\
    [Your College Name]\\
    Savitribai Phule Pune University\\
    Pune, India
}
```

---

## Summary

**Files to Compile**:
- `SALARIANN_REPORT_PART1.tex`
- `SALARIANN_REPORT_PART2.tex`
- `SALARIANN_REPORT_PART3.tex`

**Final Output**:
- `SALARIANN_COMPLETE_REPORT.pdf` (80-100 pages)

**Time Required**: ~5-10 minutes total

**Status**: ✅ Ready for compilation and submission

---

*Salariann: Intelligent Job Search and Career Analysis Platform*  
*Complete Academic Project Report in LaTeX*  
*June 2024*
