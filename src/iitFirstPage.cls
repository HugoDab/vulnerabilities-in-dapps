%! suppress = FileNotFound
\NeedsTeXFormat{LaTeX2e}
\ProvidesClass{iitFirstPage}[2022/09/08 - Template for IIT report]

\LoadClass[12pt, a4paper]{article}

\RequirePackage{graphicx}
\RequirePackage[english]{babel}
\RequirePackage[utf8]{inputenc}
\RequirePackage[T1]{fontenc}
\RequirePackage{wallpaper}
\RequirePackage{lastpage}
\RequirePackage{fancyhdr}
\RequirePackage{titlesec}
\RequirePackage{tocloft}
\RequirePackage[left=2.5cm,right=2.5cm,top=2cm,bottom=3.5cm]{geometry}

\newcommand{\studentFirstName}[1]{\renewcommand{\studentFirstName}{#1}}
\newcommand{\studentLastName}[1]{\renewcommand{\studentLastName}{#1}}
\newcommand{\reportTitle}[1]{\renewcommand{\reportTitle}{#1}}
\newcommand{\courseName}[1]{\renewcommand{\courseName}{#1}}
\newcommand{\courseID}[1]{\renewcommand{\courseID}{#1}}
\newcommand{\semester}[1]{\renewcommand{\semester}{#1}}
\newcommand{\reportDate}[1]{\renewcommand{\reportDate}{#1}}

\newcommand{\makeMargins}{

    \renewcommand\thesection{\Roman{section}.}
    \renewcommand\thesubsection{\Alph{subsection})}
    \renewcommand\thesubsubsection{\arabic{subsubsection}.}
    \renewcommand\theparagraph{(\alph{paragraph})}

    \cftsetindents{section}{0em}{2.5em}

    \setcounter{tocdepth}{4}
    \setcounter{secnumdepth}{4}

    \AddToHook{cmd/section/before}{\clearpage}

    \titlespacing{\section}{0pt}{4em}{1em}
    \titlespacing{\subsection}{2em}{2em}{1em}
    \titlespacing{\subsubsection}{4em}{1em}{1em}
    \titlespacing{\paragraph}{6em}{1em}{1em}

    \pagestyle{fancy}
    \fancyheadoffset{1.5cm}
    \setlength{\headheight}{2cm}

    \lhead{\includegraphics[scale=0.15]{first_page/iit_triangle}}
    \chead{\studentFirstName~\textsc{\studentLastName}}
    \rhead{\includegraphics[scale=0.15]{first_page/ensimag_logo}}

    \renewcommand{\footrulewidth}{0.4pt}
    \lfoot{\courseID}
    \cfoot{\reportTitle}
    \rfoot{\thepage/\pageref{LastPage}}
}

%! suppress = MissingLabel
\newcommand{\makeFirstPage}{
    \begin{titlepage}

        \ThisLRCornerWallPaper{0.38}{first_page/report_first_page_triangle}

        \centering

        \includegraphics[width=1\textwidth]{first_page/iit_logo}\par\vspace{1cm}
        \includegraphics[width=0.8\textwidth]{first_page/ensimag_logo_first_page}\par\vspace{1cm}

        {\scshape\Large \courseID~-~\courseName~-~\semester \par}

        \vspace{0.7cm}

        \rule{\linewidth}{0.2 mm} \\[0.4 cm]
        {\huge\bfseries \reportTitle \par} \
        \rule{\linewidth}{0.2 mm} \\[1 cm]

        {\scshape\Large \studentFirstName~\textsc{\studentLastName} \par}


        \begin{center}
            \centering
            \begin{tabular}{p{12cm}p{12cm}}
            {\textbf{Illinois Institute of Technology}}                                            &{\textbf{Internship advisor}}\\
            {\footnotesize }       & ~~~Yue DUAN\\
            {\footnotesize 10 West 35th Street}                                        & {\textbf{School advisor}}\\
            {\footnotesize Chicago, IL, USA}                          & ~~~Sylvain BOUVERET\\
            \end{tabular}
        \end{center}


        \vfill

        {\large \reportDate \par}

    \end{titlepage}
}
