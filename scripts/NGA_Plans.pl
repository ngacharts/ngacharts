@title = ();
@scale = ();
$chart = "";
$plan_re = '(Plan|Inset|Panel)';
# List of duplicate panel lists. 
# Delete first copy, as the first copy of 14874 and 72000 are broken
foreach (
  14874,
  21500,
  21560,
  22004,
  22405,
  22412,
  24480,
  29180,
  29282,
  42036,
  43142,
  44120,
  51621,
  52080,
  52084,
  52085,
  52086,
  56082,
  62302,
  72000,
  81012,
  83005,
  83392,
  95120,
  95320
 ) {
  $Duplicate{$_} = 1;
};

CSV_write ( "Chart nr.","Inset","Type","Title","Scale");

while (<>){
 s/\015?\012$//g;
 if (/Stock Number/) {
  # New Chart Table
  $in_charts = 1;
  # Find width of first Column, add 2 characters for column overflows
  $FirstCol = index($_,':')+2;
  next
 }

 if(/^$/ || /^Page \d\+:/) {
  # End of Charts Table
  $in_charts = 0;
  $chart = "";
  # Handle second column
  foreach (@Col2) {
   ChartLine($_);
  }
  # Reset Chart Table data
  @Col2 = ();
  $chart = "";
 }

 next unless $in_charts;

 # Process line of first column
 ChartLine(substr($_,0,$FirstCol));
 # Save second column for later
 push(@Col2, substr($_,$FirstCol));
}

sub ChartLine {
 my $_ = $_[0];

 # Special corrections
 s/C\.Takutea/C\. Takutea/;	# 83425
 s/300\.000/300,000/;		# 55160
 s/Pians: A. /Plans: A. /;	# 52086
 s/Esaki Ko/Esaki-ko/;		# 95320

 if ($ContinuedTitle && !  /A\. |${plan_re}/ ) {
  # This is not a panel but rather a continued Chart Title line 
  s/^\s*/$ContinuedTitle /;
 }
 $ContinuedTitle = "";

 my ($StockNo, $Title, $Scale) = /^\s*(\d{5}|W\d+)?\*?\s+(.*?)\s*(\d{1,3}([,.]\d{3})+|No [Ss]cale( listed?)?)?\s*$/;
 
 if (!$StockNo && !$Scale) {
  # Found a comment line
  return;
 }
 

 if ($StockNo) {
  # Avoid duplicate plans
  if ($Duplicate{$StockNo}) {
   $Duplicate{$StockNo}--;
   $chart = "";
  } else {
   # New Chart Number
   $chart = $StockNo;
  }

  # Title may indicate Plans 
  ($PlanType) = ($Title =~ /${plan_re}/);
  if (!$Scale && !$PlanType && !($Title =~ /^Anchorages in /)) {
   # We expect to find the full chart title and scale in the next line
   $ContinuedTitle = $_;
  }
  return;
 }
 # No Stock number means we've found a Plan/Inset
 if (!$chart) {
  # Skip a duplicate chat entry
  return;
 }
 
 $PlanType = $1 if 
  $Title =~ s/^${plan_re}s?:? +//;
 $Inset ="";
 $Inset = $1 if 
  $Title =~ s/^\s*([A-Z\d])[.:] ([^&])/$2/;
 $Title =~ s/\s*\([^)]*[Ii]ndex[^)]*\)//;
 $Title =~ s/\s*\([^)]*[Pp]age[^)]*\)//;
 $Scale =~ s/[.]/,/g;
 # Print in CSV format
 CSV_write ($chart, $Inset, $PlanType, $Title, $Scale);
}

sub CSV_write {
 print (
  join ("," , 
   map ('"'.$_.'"',
    @_
   )
  ),
  "\n"
 );
}

# vi:sw=1
