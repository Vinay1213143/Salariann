#!/bin/bash

# ============================================================================
# SALARIANN LATEX REPORT COMPILATION SCRIPT
# ============================================================================
# This script compiles all three LaTeX report parts and merges them into one PDF
# Usage: bash compile_report.sh
# ============================================================================

set -e  # Exit on error

# Colors for output
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m'  # No Color

# Project directory
PROJECT_DIR="/Users/bhaveshtayade/Desktop/salariann"

# Change to project directory
cd "$PROJECT_DIR"

echo -e "${BLUE}========================================${NC}"
echo -e "${BLUE}SALARIANN LATEX REPORT COMPILATION${NC}"
echo -e "${BLUE}========================================${NC}"
echo ""

# Check if LaTeX is installed
if ! command -v pdflatex &> /dev/null; then
    echo -e "${RED}❌ Error: pdflatex not found${NC}"
    echo "Please install LaTeX:"
    echo "  macOS: brew install mactex"
    echo "  Ubuntu: sudo apt-get install texlive-full"
    echo "  Windows: Download from https://miktex.org/"
    exit 1
fi

echo -e "${GREEN}✅ LaTeX installation found${NC}"
echo ""

# Check if pdftk is installed (for merging)
if ! command -v pdftk &> /dev/null; then
    echo -e "${YELLOW}⚠️  Warning: pdftk not found (needed for merging PDFs)${NC}"
    echo "Install with: brew install pdftk (macOS) or sudo apt-get install pdftk (Ubuntu)"
    echo ""
fi

# Function to compile a LaTeX file
compile_file() {
    local filename=$1
    local part_name=$2
    
    echo -e "${BLUE}Compiling ${part_name}...${NC}"
    
    if [ ! -f "$filename" ]; then
        echo -e "${RED}❌ Error: $filename not found${NC}"
        exit 1
    fi
    
    # First pass
    echo "  Pass 1..."
    pdflatex -interaction=nonstopmode "$filename" > /dev/null 2>&1
    
    # Second pass (for TOC and references)
    echo "  Pass 2..."
    pdflatex -interaction=nonstopmode "$filename" > /dev/null 2>&1
    
    echo -e "${GREEN}✅ ${part_name} compiled successfully${NC}"
}

# Compile all three parts
echo -e "${BLUE}Step 1: Compiling LaTeX files${NC}"
echo "=================================="
echo ""

compile_file "SALARIANN_REPORT_PART1.tex" "Part 1 (Chapters 1-2)"
echo ""

compile_file "SALARIANN_REPORT_PART2.tex" "Part 2 (Chapters 3-4)"
echo ""

compile_file "SALARIANN_REPORT_PART3.tex" "Part 3 (Chapters 5-8 + Appendices)"
echo ""

# Check if all PDFs were created
echo -e "${BLUE}Step 2: Verifying PDF files${NC}"
echo "=================================="
echo ""

for pdf in SALARIANN_REPORT_PART1.pdf SALARIANN_REPORT_PART2.pdf SALARIANN_REPORT_PART3.pdf; do
    if [ -f "$pdf" ]; then
        size=$(du -h "$pdf" | cut -f1)
        echo -e "${GREEN}✅ $pdf ($size)${NC}"
    else
        echo -e "${RED}❌ $pdf not found${NC}"
        exit 1
    fi
done
echo ""

# Merge PDFs if pdftk is available
if command -v pdftk &> /dev/null; then
    echo -e "${BLUE}Step 3: Merging PDFs into single document${NC}"
    echo "=========================================="
    echo ""
    
    echo "Merging SALARIANN_REPORT_PART1.pdf, PART2.pdf, and PART3.pdf..."
    
    pdftk SALARIANN_REPORT_PART1.pdf SALARIANN_REPORT_PART2.pdf SALARIANN_REPORT_PART3.pdf \
        cat output SALARIANN_COMPLETE_REPORT.pdf
    
    if [ -f "SALARIANN_COMPLETE_REPORT.pdf" ]; then
        size=$(du -h SALARIANN_COMPLETE_REPORT.pdf | cut -f1)
        echo -e "${GREEN}✅ SALARIANN_COMPLETE_REPORT.pdf created ($size)${NC}"
    else
        echo -e "${RED}❌ Failed to merge PDFs${NC}"
        exit 1
    fi
    echo ""
fi

# Optional: Clean up auxiliary files
echo -e "${BLUE}Step 4: Cleaning up auxiliary files${NC}"
echo "===================================="
echo ""

rm -f *.aux *.log *.out *.toc *.lof *.lot *.fls *.fdb_latexmk 2>/dev/null || true
echo -e "${GREEN}✅ Auxiliary files cleaned${NC}"
echo ""

# Final summary
echo -e "${BLUE}========================================${NC}"
echo -e "${GREEN}✅ COMPILATION COMPLETE!${NC}"
echo -e "${BLUE}========================================${NC}"
echo ""
echo "Generated files:"
echo "  • SALARIANN_REPORT_PART1.pdf (~25 pages)"
echo "  • SALARIANN_REPORT_PART2.pdf (~25 pages)"
echo "  • SALARIANN_REPORT_PART3.pdf (~30 pages)"

if [ -f "SALARIANN_COMPLETE_REPORT.pdf" ]; then
    echo "  • SALARIANN_COMPLETE_REPORT.pdf (~80-100 pages) ← FINAL REPORT"
fi

echo ""
echo "Location: $PROJECT_DIR"
echo ""
echo -e "${GREEN}Your report is ready for submission! 🎉${NC}"
