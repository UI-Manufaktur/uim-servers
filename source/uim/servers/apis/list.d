module uim.servers.apis.list;

@safe:
import uim.servers;

class DSRVListData : DSRVApi {
  this() {
    super();
    // this.sessionRequired(true);
  }

  mixin(SProperty!("string", "dbName"));
  mixin(SProperty!("string", "poolName"));

    
    // auto result = super.toJson(reqParameters);

    /* if (result["error"].get!int > 0) return result;
    
    string sessionId;
    if ("sessionId" in result) sessionId = result["sessionId"].get!string;

    string siteName; 
    if (auto ds = database) {
      if (siteRequired) {
        auto site = getSite(ds, result["siteId"].get!string);
        if (site == Json(null)) {
          result["error"] = 9999;
          result["status"] = 409;

          auto errorMessage = Json.emptyObject;
          errorMessage["status"] = "ERROR";
          errorMessage["title"] = "Site nicht gefunden";
          errorMessage["description"] = "Ist Ihre Site vorhanden? Bitte auswählen.";
          result["messages"] ~= errorMessage;
          return result;
        }
          
        siteName = site.name;
        result["siteName"] = siteName;
      }

      auto entities = this.app.database.findMany(siteRequired ? siteName : dbName, poolName);
      result["entities"] = entities;

      return result; */
    // }
}