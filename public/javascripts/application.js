// Place your application-specific JavaScript functions and classes here
// This file is automatically included by javascript_include_tag :defaults

function sanitize_for_subdomain(src, dest)
{
  var subdomain = new String(src.val());
  subdomain = subdomain.toLowerCase().replace(/[àâä]/gi,"a").replace(/[éèêë]/gi,"e").replace(/[ùûü]/gi,"u").replace(/[ôö]/gi,"o").replace(/[îï]/gi,"i");
  subdomain = subdomain.replace(/^www\./i, "").replace(/[^-a-z0-9]/g, "-");
  dest.val(subdomain);
}
