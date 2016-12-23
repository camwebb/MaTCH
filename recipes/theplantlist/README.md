# Extraction and assembly of the The Plant List (version 1.1)

See the documented steps in the shell script `make_plantlist.sh` for
details of the process.

The output is bzipped file thta can be loaded to a `mysql` server with
the `load_plantlist.sql` script.

NOTE (2016-12-22): I just realized that this download method is
incomplete, because genera in which all species are synonyms of
species in other genera are _not listed_ in the ‘full genus list page’
(See, e.g., _Lysiella_). There seems no other way to trigger these
genera from within TPL. An alternative method is would be to use ITIS
and GBIF etc to generate a more complete genus list and then to
