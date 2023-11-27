-- By default, custom schema name will be combined with target.schema name
-- Override this schema to based on requirements

/***
SHH 17.10.23:
Jeg la til dette skriptet for å overkjøre at tabeller default blir skrevet til det dbt genererte skjemaet. 
dbt vil alltid se her først om den skal overskrive default schema eller ikke.
Dette fører til at det i mitt tilfelle eksempelvis blir skrevet til staging.*tabellnavn* istedenfor dbt_shonningsoy.*tabellnavn*
Dette blir definert i dbt_project.yml filen for hver folder hvis ønskelig.
**/

{% macro generate_schema_name(custom_schema_name, node) -%}
    {%- set default_schema = target.schema -%}
    
    {%- if custom_schema_name is none -%}
        {{ default_schema }}
        {{ log("Setting Default Schema: {0}".format(target.schema)) }}
    {%- else -%}
        {{ custom_schema_name | trim }}
        {{ log("Setting Custom Schema: {0}".format(custom_schema_name | trim)) }}
    {%- endif -%}

{%- endmacro %}