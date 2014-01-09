<!---
    cfDateParser, A utility to aide in the parsing of various timestamps.
    https://github.com/charlesgwilson/cfDateParser

    Copyright (c) 2013, Greg Wilson (http://www.imawilson.com/)

    Licensed under the Apache License, Version 2.0 (the "License");
    you may not use this file except in compliance with the License.
    You may obtain a copy of the License at

        http://www.apache.org/licenses/LICENSE-2.0

    Unless required by applicable law or agreed to in writing, software
    distributed under the License is distributed on an "AS IS" BASIS,
    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
    See the License for the specific language governing permissions and
    limitations under the License.
--->
<cfcomponent output="false" displayname="cfDateParser" hint="A utility to aide in the parsing of various timestamps.">
    <cffunction name="parse" returntype="any" access="public" hint="Returns an empty string if no pattern is found">
        <cfargument name="dateString" required="true" type="string" />
        <cfset var _matches = "" />
        <cfset var _patterns = [] />
        <cfset var _ret = "" />
        <cfset var _sdf = createObject("java", "java.text.SimpleDateFormat") />

        <cfset arrayAppend(_patterns, ["^\d{8}$", "yyyyMMdd"]) />
        <cfset arrayAppend(_patterns, ["^\d{1,2}-\d{1,2}-\d{4}$", "dd-MM-yyyy"]) />
        <cfset arrayAppend(_patterns, ["^\d{4}-\d{1,2}-\d{1,2}$", "yyyy-MM-dd"]) />
        <cfset arrayAppend(_patterns, ["^\d{1,2}/\d{1,2}/\d{4}$", "MM/dd/yyyy"]) />
        <cfset arrayAppend(_patterns, ["^\d{4}/\d{1,2}/\d{1,2}$", "yyyy/MM/dd"]) />
        <cfset arrayAppend(_patterns, ["^\d{1,2}.\d{1,2}.\d{1,2}$", "MM.dd.yy"]) />
        <cfset arrayAppend(_patterns, ["^\d{1,2}.\d{1,2}.\d{4}$", "MM.dd.yyyy"]) />
        <cfset arrayAppend(_patterns, ["^\d{4}.\d{1,2}.\d{1,2}$", "yyyy.MM.dd"]) />
        <cfset arrayAppend(_patterns, ["^\d{1,2}\s[a-z]{3}\s\d{4}$", "dd MMM yyyy"]) />
        <cfset arrayAppend(_patterns, ["^\d{1,2}\s[a-z]{4,}\s\d{4}$", "dd MMMM yyyy"]) />
        <cfset arrayAppend(_patterns, ["^\d{12}$", "yyyyMMddHHmm"]) />
        <cfset arrayAppend(_patterns, ["^\d{8}\s\d{4}$", "yyyyMMdd HHmm"]) />
        <cfset arrayAppend(_patterns, ["^\d{1,2}-\d{1,2}-\d{4}\s\d{1,2}:\d{2}$", "dd-MM-yyyy HH:mm"]) />
        <cfset arrayAppend(_patterns, ["^\d{4}-\d{1,2}-\d{1,2}\s\d{1,2}:\d{2}$", "yyyy-MM-dd HH:mm"]) />
        <cfset arrayAppend(_patterns, ["^\d{1,2}/\d{1,2}/\d{4}\s\d{1,2}:\d{2}$", "MM/dd/yyyy HH:mm"]) />
        <cfset arrayAppend(_patterns, ["^\d{4}/\d{1,2}/\d{1,2}\s\d{1,2}:\d{2}$", "yyyy/MM/dd HH:mm"]) />
        <cfset arrayAppend(_patterns, ["^\d{1,2}.\d{1,2}.\d{1,2}\s\d{1,2}:\d{2}$", "MM.dd.yy HH:mm"]) />
        <cfset arrayAppend(_patterns, ["^\d{1,2}.\d{1,2}.\d{4}\s\d{1,2}:\d{2}$", "MM.dd.yyyy HH:mm"]) />
        <cfset arrayAppend(_patterns, ["^\d{4}.\d{1,2}.\d{1,2}\s\d{1,2}:\d{2}$", "yyyy.MM.dd HH:mm"]) />
        <cfset arrayAppend(_patterns, ["^\d{1,2}\s[a-z]{3}\s\d{4}\s\d{1,2}:\d{2}$", "dd MMM yyyy HH:mm"]) />
        <cfset arrayAppend(_patterns, ["^\d{1,2}\s[a-z]{4,}\s\d{4}\s\d{1,2}:\d{2}$", "dd MMMM yyyy HH:mm"]) />
        <cfset arrayAppend(_patterns, ["^[a-z]{3}\s\d{1,2},\s\d{4}\s\d{1,2}:\d{2}$", "MMM dd, yyyy HH:mm"]) />
        <cfset arrayAppend(_patterns, ["^\d{14}(\s?([+-]\d{2}:?\d{1,2})?([a-z]{1,3})?)?$", "yyyyMMddHHmmss"]) />
        <cfset arrayAppend(_patterns, ["^\d{8}\s\d{6}(\s?([+-]\d{2}:?\d{1,2})?([a-z]{1,3})?)?$", "yyyyMMdd HHmmss"]) />

        <cfset arrayAppend(_patterns, ["^\d{8}T\d{1,2}:\d{2}(\s?([+-]\d{2}:?\d{1,2})?([a-z]{1,3})?)?$", "yyyyMMdd'T'HH:mm"]) />
        <cfset arrayAppend(_patterns, ["^\d{8}T\d{1,2}:\d{2}(\s?([+-]\d{2}:\d{2}:\d{1,2})?([a-z]{1,3})?)?$", "yyyyMMdd'T'HH:mm"]) />
        <cfset arrayAppend(_patterns, ["^\d{8}T\d{1,2}:\d{2}:\d{2}(\s?([+-]\d{2}:?\d{1,2})?([a-z]{1,3})?)?$", "yyyyMMdd'T'HH:mm:ss"]) />
        <cfset arrayAppend(_patterns, ["^\d{8}T\d{1,2}:\d{2}:\d{2}(\s?([+-]\d{2}:\d{2}:\d{1,2})?([a-z]{1,3})?)?$", "yyyyMMdd'T'HH:mm:ss"]) />

        <cfset arrayAppend(_patterns, ["^\d{4}-\d{1,2}-\d{1,2}T\d{1,2}:\d{2}(\s?([+-]\d{2}:?\d{1,2})?([a-z]{1,3})?)?$", "yyyy-MM-dd'T'HH:mm"]) />
        <cfset arrayAppend(_patterns, ["^\d{4}-\d{1,2}-\d{1,2}T\d{1,2}:\d{2}(\s?([+-]\d{2}:\d{2}:\d{1,2})?([a-z]{1,3})?)?$", "yyyy-MM-dd'T'HH:mm"]) />
        <cfset arrayAppend(_patterns, ["^\d{4}-\d{1,2}-\d{1,2}T\d{1,2}:\d{2}:\d{2}(\s?([+-]\d{2}:?\d{1,2})?([a-z]{1,3})?)?$", "yyyy-MM-dd'T'HH:mm:ss"]) />
        <cfset arrayAppend(_patterns, ["^\d{4}-\d{1,2}-\d{1,2}T\d{1,2}:\d{2}:\d{2}(\s?([+-]\d{2}:\d{2}:\d{1,2})?([a-z]{1,3})?)?$", "yyyy-MM-dd'T'HH:mm:ss"]) />

        <cfset arrayAppend(_patterns, ["^\d{4}-\d{1,2}-\d{1,2}T\d{1,2}:\d{2}:\d{2}Z$", "yyyy-MM-dd'T'HH:mm:ss'Z'"]) />

        <cfset arrayAppend(_patterns, ["^\d{1,2}-\d{1,2}-\d{4}\s\d{1,2}:\d{2}:\d{2}(\s?([+-]\d{2}:?\d{1,2})?([a-z]{1,3})?)?$", "dd-MM-yyyy HH:mm:ss"]) />
        <cfset arrayAppend(_patterns, ["^\d{4}-\d{1,2}-\d{1,2}\s\d{1,2}:\d{2}:\d{2}(\s?([+-]\d{2}:?\d{1,2})?([a-z]{1,3})?)?$", "yyyy-MM-dd HH:mm:ss"]) />
        <cfset arrayAppend(_patterns, ["^\d{1,2}/\d{1,2}/\d{4}\s\d{1,2}:\d{2}:\d{2}(\s?([+-]\d{2}:?\d{1,2})?([a-z]{1,3})?)?$", "MM/dd/yyyy HH:mm:ss"]) />
        <cfset arrayAppend(_patterns, ["^\d{4}/\d{1,2}/\d{1,2}\s\d{1,2}:\d{2}:\d{2}(\s?([+-]\d{2}:?\d{1,2})?([a-z]{1,3})?)?$", "yyyy/MM/dd HH:mm:ss"]) />
        <cfset arrayAppend(_patterns, ["^\d{1,2}.\d{1,2}.\d{1,2}\s\d{1,2}:\d{2}:\d{2}(\s?([+-]\d{2}:?\d{1,2})?([a-z]{1,3})?)?$", "MM.dd.yy HH:mm:ss"]) />
        <cfset arrayAppend(_patterns, ["^\d{1,2}.\d{1,2}.\d{4}\s\d{1,2}:\d{2}:\d{2}(\s?([+-]\d{2}:?\d{1,2})?([a-z]{1,3})?)?$", "MM.dd.yyyy HH:mm:ss"]) />
        <cfset arrayAppend(_patterns, ["^\d{4}.\d{1,2}.\d{1,2}\s\d{1,2}:\d{2}:\d{2}(\s?([+-]\d{2}:?\d{1,2})?([a-z]{1,3})?)?$", "yyyy.MM.dd HH:mm:ss"]) />

        <cfset arrayAppend(_patterns, ["^[a-z]{3},\s\d{1,2}\s\d{4}\s\d{1,2}:\d{2}:\d{2}(\s?([+-]\d{2}:?\d{1,2})?([a-z]{1,3})?)?$", "MMM, dd yyyy HH:mm:ss"]) />
        <cfset arrayAppend(_patterns, ["^[a-z]{4,},\s\d{1,2}\s\d{4}\s\d{1,2}:\d{2}:\d{2}(\s?([+-]\d{2}:?\d{1,2})?([a-z]{1,3})?)?$", "MMMM, dd yyyy HH:mm:ss"]) />
        <cfset arrayAppend(_patterns, ["^[a-z]{3},\s\d{1,2}\s\d{4}\s\d{1,2}:\d{2}:\d{2}\s?[a-z]{2}(\s([+-]\d{2}:?\d{1,2})?([a-z]{1,3})?)?$", "MMM, dd yyyy hh:mm:ss a"]) />
        <cfset arrayAppend(_patterns, ["^[a-z]{4,},\s\d{1,2}\s\d{4}\s\d{1,2}:\d{2}:\d{2}\s?[a-z]{2}(\s([+-]\d{2}:?\d{1,2})?([a-z]{1,3})?)?$", "MMMM, dd yyyy hh:mm:ss a"]) />

        <cfset arrayAppend(_patterns, ["^[a-z]{3}\s\d{1,2},\s\d{4}\s\d{1,2}:\d{2}:\d{2}(\s?([+-]\d{2}:?\d{1,2})?([a-z]{1,3})?)?$", "MMM dd, yyyy HH:mm:ss"]) />
        <cfset arrayAppend(_patterns, ["^[a-z]{4,}\s\d{1,2},\s\d{4}\s\d{1,2}:\d{2}:\d{2}(\s?([+-]\d{2}:?\d{1,2})?([a-z]{1,3})?)?$", "MMMM dd, yyyy HH:mm:ss"]) />
        <cfset arrayAppend(_patterns, ["^[a-z]{3}\s\d{1,2},\s\d{4}\s\d{1,2}:\d{2}:\d{2}\s?[a-z]{2}(\s([+-]\d{2}:?\d{1,2})?([a-z]{1,3})?)?$", "MMM dd, yyyy hh:mm:ss a"]) />
        <cfset arrayAppend(_patterns, ["^[a-z]{4,}\s\d{1,2},\s\d{4}\s\d{1,2}:\d{2}:\d{2}\s?[a-z]{2}(\s([+-]\d{2}:?\d{1,2})?([a-z]{1,3})?)?$", "MMMM dd, yyyy hh:mm:ss a"]) />

        <cfset arrayAppend(_patterns, ["^\d{1,2}\s[a-z]{3}\s\d{4}\s\d{1,2}:\d{2}:\d{2}(\s?([+-]\d{2}:?\d{1,2})?([a-z]{1,3})?)?$", "dd MMM yyyy HH:mm:ss"]) />
        <cfset arrayAppend(_patterns, ["^\d{1,2}\s[a-z]{4,}\s\d{4}\s\d{1,2}:\d{2}:\d{2}(\s?([+-]\d{2}:?\d{1,2})?([a-z]{1,3})?)?$", "dd MMMM yyyy HH:mm:ss"]) />

        <cfset arrayAppend(_patterns, ["^[a-z]{3},\s\d{1,2}\s[a-z]{3}\s\d{4}$", "EEE, dd MMM yyyy"]) />
        <cfset arrayAppend(_patterns, ["^[a-z]{3},\s\d{1,2}\s[a-z]{4,}\s\d{4}$", "EEE, dd MMMM yyyy"]) />
        <cfset arrayAppend(_patterns, ["^[a-z]{4,},\s\d{1,2}\s[a-z]{3}\s\d{4}$", "EEEE, dd MMM yyyy"]) />
        <cfset arrayAppend(_patterns, ["^[a-z]{4,},\s\d{1,2}\s[a-z]{4,}\s\d{4}$", "EEEE, dd MMMM yyyy"]) />

        <cfset arrayAppend(_patterns, ["^[a-z]{3},\s[a-z]{3}\s\d{1,2},\s\d{4}$", "EEE, MMM dd, yyyy"]) />
        <cfset arrayAppend(_patterns, ["^[a-z]{3},\s[a-z]{4,}\s\d{1,2},\s\d{4}$", "EEE, MMMM dd, yyyy"]) />
        <cfset arrayAppend(_patterns, ["^[a-z]{4,},\s[a-z]{3}\s\d{1,2},\s\d{4}$", "EEEE, MMM dd, yyyy"]) />
        <cfset arrayAppend(_patterns, ["^[a-z]{4,},\s[a-z]{4,}\s\d{1,2},\s\d{4}$", "EEEE, MMMM dd, yyyy"]) />

        <cfset arrayAppend(_patterns, ["^[a-z]{3},\s\d{1,2}\s[a-z]{3}\s\d{2}\s\d{1,2}:\d{2}(\s?([+-]\d{2}:?\d{1,2})?([a-z]{1,3})?)?$", "EEE, dd MMM yy HH:mm"]) />
        <cfset arrayAppend(_patterns, ["^[a-z]{3},\s\d{1,2}\s[a-z]{4,}\s\d{2}\s\d{1,2}:\d{2}(\s?([+-]\d{2}:?\d{1,2})?([a-z]{1,3})?)?$", "EEE, dd MMMM yy HH:mm"]) />
        <cfset arrayAppend(_patterns, ["^[a-z]{4,},\s\d{1,2}\s[a-z]{3}\s\d{2}\s\d{1,2}:\d{2}(\s?([+-]\d{2}:?\d{1,2})?([a-z]{1,3})?)?$", "EEEE, dd MMM yy HH:mm"]) />
        <cfset arrayAppend(_patterns, ["^[a-z]{4,},\s\d{1,2}\s[a-z]{4,}\s\d{2}\s\d{1,2}:\d{2}(\s?([+-]\d{2}:?\d{1,2})?([a-z]{1,3})?)?$", "EEEE, dd MMMM yy HH:mm"]) />

        <cfset arrayAppend(_patterns, ["^[a-z]{3},\s\d{1,2}\s[a-z]{3}\s\d{4}\s\d{1,2}:\d{2}(\s?([+-]\d{2}:?\d{1,2})?([a-z]{1,3})?)?$", "EEE, dd MMM yyyy HH:mm"]) />
        <cfset arrayAppend(_patterns, ["^[a-z]{3},\s\d{1,2}\s[a-z]{4,}\s\d{4}\s\d{1,2}:\d{2}(\s?([+-]\d{2}:?\d{1,2})?([a-z]{1,3})?)?$", "EEE, dd MMMM yyyy HH:mm"]) />
        <cfset arrayAppend(_patterns, ["^[a-z]{4,},\s\d{1,2}\s[a-z]{3}\s\d{4}\s\d{1,2}:\d{2}(\s?([+-]\d{2}:?\d{1,2})?([a-z]{1,3})?)?$", "EEEE, dd MMM yyyy HH:mm"]) />
        <cfset arrayAppend(_patterns, ["^[a-z]{4,},\s\d{1,2}\s[a-z]{4,}\s\d{4}\s\d{1,2}:\d{2}(\s?([+-]\d{2}:?\d{1,2})?([a-z]{1,3})?)?$", "EEEE, dd MMMM yyyy HH:mm"]) />

        <cfset arrayAppend(_patterns, ["^[a-z]{3},\s\d{1,2}\s[a-z]{3}\s\d{2}\s\d{1,2}:\d{2}:\d{2}(\s?([+-]\d{2}:?\d{1,2})?([a-z]{1,3})?)?$", "EEE, dd MMM yy HH:mm:ss"]) />
        <cfset arrayAppend(_patterns, ["^[a-z]{3},\s\d{1,2}\s[a-z]{4,}\s\d{2}\s\d{1,2}:\d{2}:\d{2}(\s?([+-]\d{2}:?\d{1,2})?([a-z]{1,3})?)?$", "EEE, dd MMMM yy HH:mm:ss"]) />
        <cfset arrayAppend(_patterns, ["^[a-z]{4,},\s\d{1,2}\s[a-z]{3}\s\d{2}\s\d{1,2}:\d{2}:\d{2}(\s?([+-]\d{2}:?\d{1,2})?([a-z]{1,3})?)?$", "EEEE, dd MMM yy HH:mm:ss"]) />
        <cfset arrayAppend(_patterns, ["^[a-z]{4,},\s\d{1,2}\s[a-z]{4,}\s\d{2}\s\d{1,2}:\d{2}:\d{2}(\s?([+-]\d{2}:?\d{1,2})?([a-z]{1,3})?)?$", "EEEE, dd MMMM yy HH:mm:ss"]) />

        <cfset arrayAppend(_patterns, ["^[a-z]{3},\s\d{1,2}\s[a-z]{3}\s\d{2},\s\d{1,2}:\d{2}:\d{2}(\s?([+-]\d{2}:?\d{1,2})?([a-z]{1,3})?)?$", "EEE, dd MMM yy, HH:mm:ss"]) />
        <cfset arrayAppend(_patterns, ["^[a-z]{3},\s\d{1,2}\s[a-z]{4,}\s\d{2},\s\d{1,2}:\d{2}:\d{2}(\s?([+-]\d{2}:?\d{1,2})?([a-z]{1,3})?)?$", "EEE, dd MMMM yy, HH:mm:ss"]) />
        <cfset arrayAppend(_patterns, ["^[a-z]{4,},\s\d{1,2}\s[a-z]{3}\s\d{2},\s\d{1,2}:\d{2}:\d{2}(\s?([+-]\d{2}:?\d{1,2})?([a-z]{1,3})?)?$", "EEEE, dd MMM yy, HH:mm:ss"]) />
        <cfset arrayAppend(_patterns, ["^[a-z]{4,},\s\d{1,2}\s[a-z]{4,}\s\d{2},\s\d{1,2}:\d{2}:\d{2}(\s?([+-]\d{2}:?\d{1,2})?([a-z]{1,3})?)?$", "EEEE, dd MMMM yy, HH:mm:ss"]) />

        <cfset arrayAppend(_patterns, ["^[a-z]{3},\s\d{1,2}\s[a-z]{3}\s\d{4}\s\d{1,2}:\d{2}:\d{2}(\s?([+-]\d{2}:?\d{1,2})?([a-z]{1,3})?)?$", "EEE, dd MMM yyyy HH:mm:ss"]) />
        <cfset arrayAppend(_patterns, ["^[a-z]{3},\s\d{1,2}\s[a-z]{4,}\s\d{4}\s\d{1,2}:\d{2}:\d{2}(\s?([+-]\d{2}:?\d{1,2})?([a-z]{1,3})?)?$", "EEE, dd MMMM yyyy HH:mm:ss"]) />
        <cfset arrayAppend(_patterns, ["^[a-z]{4,},\s\d{1,2}\s[a-z]{3}\s\d{4}\s\d{1,2}:\d{2}:\d{2}(\s?([+-]\d{2}:?\d{1,2})?([a-z]{1,3})?)?$", "EEEE, dd MMM yyyy HH:mm:ss"]) />
        <cfset arrayAppend(_patterns, ["^[a-z]{4,},\s\d{1,2}\s[a-z]{4,}\s\d{4}\s\d{1,2}:\d{2}:\d{2}(\s?([+-]\d{2}:?\d{1,2})?([a-z]{1,3})?)?$", "EEEE, dd MMMM yyyy HH:mm:ss"]) />

        <cfset arrayAppend(_patterns, ["^[a-z]{3},\s\d{1,2}\s[a-z]{3}\s\d{4},\s\d{1,2}:\d{2}(\s?([+-]\d{2}:?\d{1,2})?([a-z]{1,3})?)?$", "EEE, dd MMM yyyy, HH:mm"]) />
        <cfset arrayAppend(_patterns, ["^[a-z]{3},\s\d{1,2}\s[a-z]{4,}\s\d{4},\s\d{1,2}:\d{2}(\s?([+-]\d{2}:?\d{1,2})?([a-z]{1,3})?)?$", "EEE, dd MMMM yyyy, HH:mm"]) />
        <cfset arrayAppend(_patterns, ["^[a-z]{4,},\s\d{1,2}\s[a-z]{3}\s\d{4},\s\d{1,2}:\d{2}(\s?([+-]\d{2}:?\d{1,2})?([a-z]{1,3})?)?$", "EEEE, dd MMM yyyy, HH:mm"]) />
        <cfset arrayAppend(_patterns, ["^[a-z]{4,},\s\d{1,2}\s[a-z]{4,}\s\d{4},\s\d{1,2}:\d{2}(\s?([+-]\d{2}:?\d{1,2})?([a-z]{1,3})?)?$", "EEEE, dd MMMM yyyy, HH:mm"]) />

        <cfset arrayAppend(_patterns, ["^[a-z]{3},\s\d{1,2}\s[a-z]{3}\s\d{4},\s\d{1,2}:\d{2}:\d{2}(\s?([+-]\d{2}:?\d{1,2})?([a-z]{1,3})?)?$", "EEE, dd MMM yyyy, HH:mm:ss"]) />
        <cfset arrayAppend(_patterns, ["^[a-z]{3},\s\d{1,2}\s[a-z]{4,}\s\d{4},\s\d{1,2}:\d{2}:\d{2}(\s?([+-]\d{2}:?\d{1,2})?([a-z]{1,3})?)?$", "EEE, dd MMMM yyyy, HH:mm:ss"]) />
        <cfset arrayAppend(_patterns, ["^[a-z]{4,},\s\d{1,2}\s[a-z]{3}\s\d{4},\s\d{1,2}:\d{2}:\d{2}(\s?([+-]\d{2}:?\d{1,2})?([a-z]{1,3})?)?$", "EEEE, dd MMM yyyy, HH:mm:ss"]) />
        <cfset arrayAppend(_patterns, ["^[a-z]{4,},\s\d{1,2}\s[a-z]{4,}\s\d{4},\s\d{1,2}:\d{2}:\d{2}(\s?([+-]\d{2}:?\d{1,2})?([a-z]{1,3})?)?$", "EEEE, dd MMMM yyyy, HH:mm:ss"]) />

        <cfset arrayAppend(_patterns, ["^[a-z]{3},\s\d{1,2}\s[a-z]{3}\s\d{4}\s\d{1,2}:\d{2}:\d{2}\s[a-z]{2}(\s?([+-]\d{2}:?\d{1,2})?([a-z]{1,3})?)?$", "EEE, dd MMM yyyy hh:mm:ss a"]) />
        <cfset arrayAppend(_patterns, ["^[a-z]{3},\s\d{1,2}\s[a-z]{4,}\s\d{4}\s\d{1,2}:\d{2}:\d{2}\s[a-z]{2}(\s?([+-]\d{2}:?\d{1,2})?([a-z]{1,3})?)?$", "EEE, dd MMMM yyyy hh:mm:ss a"]) />
        <cfset arrayAppend(_patterns, ["^[a-z]{4,},\s\d{1,2}\s[a-z]{3}\s\d{4}\s\d{1,2}:\d{2}:\d{2}\s[a-z]{2}(\s?([+-]\d{2}:?\d{1,2})?([a-z]{1,3})?)?$", "EEEE, dd MMM yyyy hh:mm:ss a"]) />
        <cfset arrayAppend(_patterns, ["^[a-z]{4,},\s\d{1,2}\s[a-z]{4,}\s\d{4}\s\d{1,2}:\d{2}:\d{2}\s[a-z]{2}(\s?([+-]\d{2}:?\d{1,2})?([a-z]{1,3})?)?$", "EEEE, dd MMMM yyyy hh:mm:ss a"]) />

        <cfset arrayAppend(_patterns, ["^[a-z]{3},\s\d{1,2}\s[a-z]{3}\s\d{4},\s\d{1,2}:\d{2}:\d{2}\s[a-z]{2}(\s?([+-]\d{2}:?\d{1,2})?([a-z]{1,3})?)?$", "EEE, dd MMM yyyy, hh:mm:ss a"]) />
        <cfset arrayAppend(_patterns, ["^[a-z]{3},\s\d{1,2}\s[a-z]{4,}\s\d{4},\s\d{1,2}:\d{2}:\d{2}\s[a-z]{2}(\s?([+-]\d{2}:?\d{1,2})?([a-z]{1,3})?)?$", "EEE, dd MMMM yyyy, hh:mm:ss a"]) />
        <cfset arrayAppend(_patterns, ["^[a-z]{4,},\s\d{1,2}\s[a-z]{3}\s\d{4},\s\d{1,2}:\d{2}:\d{2}\s[a-z]{2}(\s?([+-]\d{2}:?\d{1,2})?([a-z]{1,3})?)?$", "EEEE, dd MMM yyyy, hh:mm:ss a"]) />
        <cfset arrayAppend(_patterns, ["^[a-z]{4,},\s\d{1,2}\s[a-z]{4,}\s\d{4},\s\d{1,2}:\d{2}:\d{2}\s[a-z]{2}(\s?([+-]\d{2}:?\d{1,2})?([a-z]{1,3})?)?$", "EEEE, dd MMMM yyyy, hh:mm:ss a"]) />

        <cfset arrayAppend(_patterns, ["^[a-z]{3},\s[a-z]{3}\s\d{1,2}\s\d{4}\s\d{1,2}:\d{2}(\s?([+-]\d{2}:?\d{1,2})?([a-z]{1,3})?)?$", "EEE, MMM dd yyyy HH:mm"]) />
        <cfset arrayAppend(_patterns, ["^[a-z]{3},\s[a-z]{4,}\s\d{1,2}\s\d{4}\s\d{1,2}:\d{2}(\s?([+-]\d{2}:?\d{1,2})?([a-z]{1,3})?)?$", "EEE, MMMM dd yyyy HH:mm"]) />
        <cfset arrayAppend(_patterns, ["^[a-z]{4,},\s[a-z]{3}\s\d{1,2}\s\d{4}\s\d{1,2}:\d{2}(\s?([+-]\d{2}:?\d{1,2})?([a-z]{1,3})?)?$", "EEEE, MMM dd yyyy HH:mm"]) />
        <cfset arrayAppend(_patterns, ["^[a-z]{4,},\s[a-z]{4,}\s\d{1,2}\s\d{4}\s\d{1,2}:\d{2}(\s?([+-]\d{2}:?\d{1,2})?([a-z]{1,3})?)?$", "EEEE, MMMM dd yyyy HH:mm"]) />

        <cfset arrayAppend(_patterns, ["^[a-z]{3},\s[a-z]{3}\s\d{1,2}\s\d{4}\s\d{1,2}:\d{2}:\d{2}(\s?([+-]\d{2}:?\d{1,2})?([a-z]{1,3})?)?$", "EEE, MMM dd yyyy HH:mm:ss"]) />
        <cfset arrayAppend(_patterns, ["^[a-z]{3},\s[a-z]{4,}\s\d{1,2}\s\d{4}\s\d{1,2}:\d{2}:\d{2}(\s?([+-]\d{2}:?\d{1,2})?([a-z]{1,3})?)?$", "EEE, MMMM dd yyyy HH:mm:ss"]) />
        <cfset arrayAppend(_patterns, ["^[a-z]{4,},\s[a-z]{3}\s\d{1,2}\s\d{4}\s\d{1,2}:\d{2}:\d{2}(\s?([+-]\d{2}:?\d{1,2})?([a-z]{1,3})?)?$", "EEEE, MMM dd yyyy HH:mm:ss"]) />
        <cfset arrayAppend(_patterns, ["^[a-z]{4,},\s[a-z]{4,}\s\d{1,2}\s\d{4}\s\d{1,2}:\d{2}:\d{2}(\s?([+-]\d{2}:?\d{1,2})?([a-z]{1,3})?)?$", "EEEE, MMMM dd yyyy HH:mm:ss"]) />

        <cfloop array="#_patterns#" index="_pattern">
            <cfset _matches = reMatchNoCase(_pattern[1], arguments.dateString)>
            <cfif arrayLen(_matches)>
                <cfset _sdf.applyPattern(_pattern[2]) />
                <cfset _ret = _sdf.parse(arguments.dateString) />
                <cfbreak />
            </cfif>
        </cfloop>
        <cfreturn _ret />
    </cffunction>
</cfcomponent>