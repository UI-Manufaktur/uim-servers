module uim.servers.mixins;

@safe:
import uim.servers;

mixin template ImportPhobos() {
  // Phobos
  public import std.algorithm; 
  public import std.range; 
  public import std.range.primitives; 
  public import std.range.interfaces; 
  public import std.base64;
  public import std.csv;
  // public import std.json;
  public import std.zip; // Read/write data in the ZIP archive format.
  public import std.zlib;
  public import std.stdio;
  public import std.string;
  public import std.uuid;
  public import std.digest; // Compute digests such as md5, sha1 and crc32.
  public import std.digest.crc; // Cyclic Redundancy Check (32-bit) implementation.
  public import std.digest.hmac; // Compute HMAC digests of arbitrary data.
  public import std.digest.md; // Compute MD5 hash of arbitrary data.
  public import std.digest.murmurhash; // Compute MurmurHash of arbitrary data.
  public import std.digest.ripemd; // Compute RIPEMD-160 hash of arbitrary data.
  public import std.digest.sha; // Compute SHA1 and SHA2 hashes of arbitrary data.
  public import std.file; // Manipulate files and directories.
  public import std.path; // Manipulate strings that represent filesystem paths.
  public import std.stdio; // Perform buffered I/O.
  // Networking
  public import std.socket; // Socket primitives.
  public import std.net.curl; // Networking client functionality as provided by libcurl.
  public import std.net.isemail; // Validates an email address according to RFCs 5321, 5322 and others.
  public import std.uri; // Encode and decode Uniform Resource Identifiers (URIs).
  public import std.uuid; // Universally-unique identifiers for resources in distributed systems.
  // Numeric
  public import std.bigint; // An arbitrary-precision integer type.
  public import std.complex; // A complex number type.
  public import std.math; // Elementary mathematical functions (powers, roots, trigonometry).
  public import std.mathspecial; // Families of transcendental functions.
  public import std.numeric; // Floating point numerics functions.
  public import std.random; // Pseudo-random number generators.
  // String manipulation
  public import std.string; // Algorithms that work specifically with strings.
  public import std.array; // Manipulate builtin arrays.
  public import std.algorithm; // Generic algorithms for processing sequences.
  public import std.uni; // Fundamental Unicode algorithms and data structures.
  public import std.utf; // Encode and decode UTF-8, UTF-16 and UTF-32 strings.
  public import std.format; // Format data into strings.
  public import std.path; // Manipulate strings that represent filesystem paths.
  public import std.regex; // Regular expressions.
  public import std.ascii; // Routines specific to the ASCII subset of Unicode.
  public import std.encoding; // Handle and transcode between various text encodings.
  public import std.windows.charset; // Windows specific character set support.
  public import std.outbuffer; // Serialize data to ubyte arrays.
  //
  public import std.getopt; // Serialize data to ubyte arrays.
  public import std.typecons;
}

mixin template ImportDubs() {
  public import vibe.d;
}

mixin template ImportUim() {
  public import uim.core;
  public import uim.oop;
  public import uim.html;
  public import uim.javascript;
  public import uim.bootstrap;
  public import uim.entities;
}

template ImportLocal(string name) {
  const char[] ImportLocal = `
//public import servers.`~name~`.apis;
public import servers.`~name~`.components;
//public import servers.`~name~`.layouts;
//public import servers.`~name~`.pages;
  `;
}

mixin template DefaultConfig(string appName, int portHttp = 9000, int portHttps = 9100) {
  // Defaults
  auto configFile = "config.json";
  auto serverName = appName;  
  auto rootPath = "/";
  auto serverMode = "debug";  
  auto httpMode = "OnlyHttp";
  // http
  ushort httpPort = portHttp;
  auto httpAddresses = ["::1", "127.0.0.1"];
  auto httpLogFormat = `{ "app":"`~appName~`", "ipaddress":"%h", "timerequest":"%t", "getrequest":"%r", "statuscode":%s, "sizeresponse":%b, "referer":"%{Referer}i", "useragent":"%{User-Agent}i"}`;
  // https
  ushort httpsPort = portHttps;
  auto httpsAddresses = ["::1", "127.0.0.1"];
  auto httpsLogFormat = `{ "app":"`~appName~`", "ipaddress":"%h", "timerequest":"%t", "getrequest":"%r", "statuscode":%s, "sizeresponse":%b, "referer":"%{Referer}i", "useragent":"%{User-Agent}i"}`;
  auto tlsChain = "";
  auto tlsPrivate = "";
  // Database
  auto dbMode = "mongo";
  auto dbString = "mongodb://127.0.0.1:27018/?safe=true";
  // Logging
  auto logMode = "file";
  auto logPath = "logs";
}

mixin template ReadConfig() {
  void readConfig() {
    Json serverConfig = Json.emptyObject;
    if (configFile.exists) {
      try {
        serverConfig = parseJsonString(readText(configFile)); 

        foreach(kv; serverConfig.byKeyValue) {
          switch(kv.key) {
            // Config general
            case "serverName": serverName = kv.value.get!string; break;
            case "serverMode": serverMode = kv.value.get!string; break;
            case "rootPath": rootPath = kv.value.get!string; break;
            case "httpMode": httpMode = kv.value.get!string; break;
            // Config http
            case "httpPort": httpPort = kv.value.get!ushort; break;
            case "httpAddresses": httpAddresses = null;
              foreach(v; kv.value.get!(Json[])) httpAddresses ~= v.get!string; 
              break;
            case "httpLogFormat": httpLogFormat = kv.value.get!string; break;
            // Config https
            case "httpsPort": httpsPort = kv.value.get!ushort; break;
            case "httpsAddresses": httpsAddresses = null;
              foreach(v; kv.value.get!(Json[])) httpsAddresses ~= v.get!string; 
              break;
            case "httpsLogFormat": httpsLogFormat = kv.value.get!string; break;
            case "tlsChain": tlsChain = kv.value.get!string; break;
            case "tlsPrivate": tlsPrivate = kv.value.get!string; break;
            // Database
            case "dbMode": dbMode = kv.value.get!string; break;
            case "dbString": dbString = kv.value.get!string; break;
            // Logging
            case "logMode": logMode = kv.value.get!string; break;
            case "logPath": logPath = kv.value.get!string; break;
            default: break;
          }
        }
      }
      catch(Exception e) {
        writeln(e);
      }
    }
    if (!logPath.exists) logPath.mkdir;
  }
}

mixin template GetoptConfig() {
  auto helpInformation = std.getopt.getopt(
    args,
    // App or Server specific 
    "serverName",  &serverName,    
    "serverMode",  &serverMode,    
    "rootPath",  &rootPath,    
    // Http - Https
    "httpMode",    &httpMode,      
    //https
    "httpPort", &httpPort,   
    "httpAddresses", &httpAddresses,   
    "httpLogFormat", &httpLogFormat,   
    // Https
    "httpsPort", &httpsPort,   
    "httpsAddresses", &httpsAddresses,   
    "httpsLogFormat", &httpsLogFormat,   
    "tlsChain", &tlsChain,   
    "tlsPrivate", &tlsPrivate,   
    // Database
    "dbMode", &dbMode,   
    "dbString", &dbString,   
    // Loghing
    "logMode", &logMode,   
    "logPath", &logPath   
  );
}

template SetRouterDefault() {
  const char[] SetRouterDefault = `
  auto pathToBaseResources = "../../PUBLIC/";
	router
		.get("/css/*", serveStaticFiles(pathToBaseResources))
		.get("/data/*", serveStaticFiles(pathToBaseResources))
		.get("/lib/*", serveStaticFiles(pathToBaseResources))
		.get("/font/*", serveStaticFiles(pathToBaseResources))
		.get("/img/*", serveStaticFiles(pathToBaseResources))
		.get("/js/*", serveStaticFiles(pathToBaseResources))
		.get("/vue/*", serveStaticFiles(pathToBaseResources))
		.get("/react/*", serveStaticFiles(pathToBaseResources))
		.get("/theme/*", serveStaticFiles(pathToBaseResources))
		.get("/font/*", serveStaticFiles(pathToBaseResources))
		.get("/templ/*", serveStaticFiles(pathToBaseResources))
		.get("/plugin/*", serveStaticFiles(pathToBaseResources))
		.get("/page/*", serveStaticFiles(pathToBaseResources));
  `;
}

template SetHTTP() {
  const char[] SetHTTP = `
  if ((httpMode == "OnlyHttp") || (httpMode == "HttpAndHttps")) {
    auto settings = new HTTPServerSettings;
    settings.port = httpPort;
    settings.bindAddresses = httpAddresses;
    settings.sessionStore = new MemorySessionStore;
    settings.accessLogger = new vibe.http.log.HTTPFileLogger(settings, httpLogFormat, "./logs/"~serverName~"-http-"~now().toISOString~".log");
    listenHTTP(settings, router);
  }
  if ((httpMode == "OnlyHttps") || (httpMode == "HttpAndHttps")) {
    auto settings = new HTTPServerSettings;
    settings.port = httpPort;
    settings.sessionStore = new MemorySessionStore;
    settings.bindAddresses = httpsAddresses;
    settings.accessLogger = new vibe.http.log.HTTPFileLogger(settings, httpsLogFormat, "./logs/"~serverName~"-https-"~now().toISOString~".log");
    settings.tlsContext = createTLSContext(TLSContextKind.server);
    settings.tlsContext.useCertificateChainFile(tlsChain);	
    settings.tlsContext.usePrivateKeyFile(tlsPrivate);
    listenHTTP(settings, router);
  }`;
}