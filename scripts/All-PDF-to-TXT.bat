for %%P in (nga*.pdf) do pdf_to_text-tool --file %%P | perl NGA_Plans.pl > %%~nP.csv
copy nga*.csv all-nga.csv
