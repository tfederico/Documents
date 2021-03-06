#!/usr/bin/perl -w
use XML::LibXML;
use strict;
use utf8;
#\\sectionfont{\\fontsize{0}{0}\\selectfont}
#\\item\\makebox[\\linewidth]{\\Large\\textbf{\\glsgetgrouptitle{##1}}}%
my $file = "Glossario.xml";
my $parser=XML::LibXML->new();                      #creazione del parser
my $doc=$parser->parse_file($file) || die("file non trovato \n");   #parsing del file
my $root=$doc->getDocumentElement;                  #estrazione radice
my @voci = $root->getElementsByTagName("voce");
my $newfile = "\\documentclass[a4paper]{article}
\\usepackage{leaf}
\\usepackage[nonumberlist]{glossaries}
\\usepackage{titletoc}
\\usepackage{titlesec}



\\titlepage{}
\\newglossarystyle{myaltlistgroup}{%
\\setcounter{page}{1}
  \\setglossarystyle{altlistgroup}%
  \\renewcommand*{\\glsgroupheading}[1]{%
   \\newpage
    \\section{##1}%
    \\vspace*{-\\baselineskip}%
	
    \\item\\makebox[\\linewidth]{\\hspace*{4cm}\\hrulefill\\hspace*{2cm}}%
  	
  }%
}



\\newcommand\\invisiblesection[1]{%
  \\refstepcounter{subsection}%
  \\addcontentsline{toc}{subsection}{\\protect\\numberline{\\thesection}#1}%
  \\sectionmark{#1}
}

\\renewcommand{\\glossarysection}[2][]{}
\\intestazioni{Glossario}";
foreach my $voce (@voci) {
    my $termine = $voce->findvalue("termine");
    $termine =~ s/^\s+|\s+$//g;
    $termine = ucfirst($termine);
    my $descrizione = $voce->findvalue("descrizione");
    $descrizione =~ s/^\s+|\s+$//g;
    $descrizione = ucfirst($descrizione);
    $newfile = $newfile."\\newglossaryentry{$termine}{name=$termine,description={\\invisiblesection{$termine}$descrizione}}\n";
}

$newfile = $newfile."\\makeglossaries
\\author{Zanella Marco}
\\date{07/12/2015}

\\pagenumbering{gobble}
\\setcounter{secnumdepth}{2}
\\begin{document}
\\begin{titlepage}
	\\centering
	{\\huge\\bfseries CLIPS\\par}
	Communication \\& Localization with Indoor Positioning Systems \\\\*
	\\line(1,0){350} \\\\
	{\\scshape\\LARGE Università di Padova \\par}
	\\vspace{1cm}
	%devono essere cambiato il titolo ogni volta
	{\\scshape\\Large Glossario v6.00\\par}
	\\logo
	\\newpage
		\\begin{tabular}{c|c}
			{\\hfill \\textbf{Versione}} 			& 6.00				\\\\[1ex]
			{\\hfill\\textbf{Data Redazione}} 		& 2015-06-12  			\\\\[1ex]
			{\\hfill\\textbf{Redazione}} 			& Oscar Elia Conti      		\\\\[1ex]
			{\\hfill\\textbf{Verifica}} 			& Eduard Bicego			\\\\[1ex]
			{\\hfill\\textbf{Approvazione}} 		& Andrea Tombolato		\\\\[1ex] 
			{\\hfill\\textbf{Uso}} 				& Esterno			\\\\[1ex]
			{\\hfill\\textbf{Distribuzione}} 		& Prof. Vardanega Tullio	\\\\[1ex]
                                                    			& Prof. Cardin Riccardo		\\\\[1ex]
                                                    			& Miriade S.p.A.		\\\\[1ex]
		\\end{tabular}
	\\end{titlepage}

	
		
		\\include{DiarioModificheG}
		
		\\newpage		
		\\titlecontents{section}[1em]
		{\\vskip 1ex}
		{\\scshape\\bfseries\\fontsize{2em}{2em}\\selectfont}
		{\\itshape}
		{}
		\\titlecontents{subsection}[2em]
		{}
		{}
		{}
		{\\titlerule\\contentspage}
		\\tableofcontents
	\\label{LastFrontPage}
	\\pagebreak
	\\pagestyle{mymain}
	\\titleformat{\\section}[block]{\\bfseries\\filcenter\\fontsize{25pt}{25pt}\\selectfont}{}{1em}{}	
			
	\\printglossary[style=myaltlistgroup, nonumberlist]
	\\glsaddall	
	\\label{LastPage}
\\end{document}";

$file = "Glossario.tex";
open(OUT, ">$file");                            #apertura file 
print OUT $newfile;                       #serializzazione + salvataggio
close(OUT);
