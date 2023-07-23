
options orientation=landscape nodate nonumber; 
title " ";

data class; 
length region $20.; 
set sashelp.class;
region='USA'; output;
region='Europe'; output;
region='Australia'; output; 
col1=' ';
run;

%macro custom;
	ODS PATH work.custom(update) sasuser.templat(read)
		sashelp.tmplmst(read);
	ods path show;

	proc template;
		define style Styles.Custom;
			parent = Styles.rtf;
			replace fonts /
				'TitleFont2' = ("Courier New", 8pt)
				'TitleFont' = ("Courier New", 8pt)
				'StrongFont' = ("Courier New", 8pt)
				'EmphasisFont' = ("Courier New", 8pt, Bold)
				'FixedEmphasisFont' = ("Courier New", 8pt, Bold)
				'FixedStrongFont' = ("Courier New", 8pt)
				'FixedHeadingFont' = ("Courier New", 8pt)
				'BatchFixedFont' = ("Courier New", 8pt)
				'FixedFont' = ("Courier New", 8pt)
				'headingEmphasisFont' = ("Courier New", 8pt)
				'headingFont' = ("Courier New", 8pt)
				'docFont' = ("Courier New", 8pt);
			style SystemTitle from TitlesAndFooters /
				protectspecialchars=off
				asis=on
				font=Fonts('TitleFont');
			replace Output from Container /
				frame = VOID
				rules = NONE
				background=_undef_
				frameborder=OFF;
			replace color_list /
				'bg' = cxFFFFFF
				'fg' = cx000000;
			replace colors /
				'headerfgemph' = color_list('fg')
				'headerbgemph' = color_list('bg')
				'headerfgstrong' = color_list('fg')
				'headerbgstrong' = color_list('bg')
				'headerfg' = color_list('fg')
				'headerbg' = color_list('bg')
				'datafgemph' = color_list('fg')
				'databgemph' = color_list('bg')
				'datafgstrong' = color_list('fg')
				'databgstrong' = color_list('bg')
				'datafg' = color_list('fg')
				'databg' = color_list('bg')
				'batchfg' = color_list('fg')
				'batchbg' = color_list('bg')
				'tableborder' = color_list('fg')
				'tablebg' = color_list('bg')
				'notefg' = color_list('fg')
				'notebg' = color_list('bg')
				'bylinefg' = color_list('fg')
				'bylinebg' = color_list('bg')
				'captionfg' = color_list('fg')
				'captionbg' = color_list('bg')
				'proctitlefg' = color_list('fg')
				'proctitlebg' = color_list('bg')
				'titlefg' = color_list('fg')
				'titlebg' = color_list('bg')
				'systitlefg' = color_list('fg')
				'systitlebg' = color_list('bg')
				'Conentryfg' = color_list('fg')
				'Confolderfg' = color_list('fg')
				'Contitlefg' = color_list('fg')
				'link2' = color_list('fg')
				'link1' = color_list('fg')
				'contentfg' = color_list('fg')
				'contentbg' = color_list('bg')
				'docfg' = color_list('fg')
				'docbg' = color_list('bg');
			replace Body from Document /


				bottommargin = 0.9in
				topmargin = 1.0in
				rightmargin = 1.0in
				leftmargin = 1.0in

				pagebreakhtml = html('PageBreakLine');
			replace SystemFooter from TitlesAndFooters /
				font = Fonts('TitleFont')
				just=left
				asis=on
				cellpadding=0
				cellspacing=0;
			style table from output /
				background=_Undef_
				frame=above /* outside borders: void, box, above/below, vsides/hsides, lhs/rhs */
			rules=groups /* internal borders: none, all, cols, rows, groups */
			borderwidth = 0.4pt /* the width of the borders and rules, applies to frame (the outer border) and headline */
			cellpadding = 1   /* the space between table cell contents and the cell border */
			cellspacing = 0   /* the space between table cells, allows background to show */;
			style Header from header /
			background=_undef_
			frame=below
			rules=rows
			font = fonts('HeadingFont')
			foreground = colors('headerfg')
			background = colors('headerbg');
			style Rowheader from Rowheader /
				rules=rows
				background=_undef_
				frame=below;
		end;
	run;

%mend;

%custom; 


%let numcol=5;
%let totwidth=8.6;
ods escapechar='~'; 


ods rtf file="C:\reporting\class.rtf" style=custom;

proc report data=class headline headskip split='^' style = [outputwidth=100% cellpadding=1]
style(header)=[asis=on just=c protectspecialchars=off]
style(column)=[asis=on just=c protectspecialchars=off];


columns region name 
 ("~S={borderbottomcolor=black borderbottomwidth=2} SEX AND AGE" sex age) 
("~S={borderbottomcolor=white borderbottomwidth=2} " col1)
 ("~S={borderbottomcolor=black borderbottomwidth=2} HEIGHT AND WEIGHT" height weight) 

; 

define region/group noprint;
define name/'Name' style(column)={ cellwidth=%sysevalf(&totwidth/&numcol) in} 
			style(header)={just=left cellwidth=%sysevalf(&totwidth/&numcol) in};
define sex/'Sex' style(column)={ cellwidth=%sysevalf(&totwidth/&numcol) in} 
			style(header)={just=left cellwidth=%sysevalf(&totwidth/&numcol) in};
define age/'Age' style(column)={ cellwidth=%sysevalf(&totwidth/&numcol) in} 
			style(header)={just=right cellwidth=%sysevalf(&totwidth/&numcol) in};

define col1/' ' style(column)={ cellwidth=0.2 in} 
			style(header)={just=right cellwidth=0.2 in};


define height/'Height' style(column)={ cellwidth=%sysevalf(&totwidth/&numcol) in} 
			style(header)={just=right cellwidth=%sysevalf(&totwidth/&numcol) in};
define weight/'Weight' style(column)={ cellwidth=%sysevalf(&totwidth/&numcol) in} 
			style(header)={just=right cellwidth=%sysevalf(&totwidth/&numcol) in};


compute before region; 
line @1 region $30.; 
endcomp; 

compute after region; 
line @1 ' '; 
endcomp; 


compute name; 
call define(_col_, "style", "style={leftmargin=.15in}");
endcomp;


title1  font='Arial' height=0.7 j=left "YYY consulting, Inc." j=right "Page ~{pageof}";
title2 j=center font='Arial' height=0.7 "Table 14.1: Demographics and Baseline Characteristics"; 
title3 j=center font='Arial' height=0.7 "Safety Population"; 

footnote1 justify=l "~R'\brdrt\brdrs\brdrw5'";
footnote2 justify=l "Generated by report_rtf.sas, &sysdate &systime SAS &sysver in &sysscpl"; 


run;

ods rtf close;

