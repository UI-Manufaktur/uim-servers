module uim.servers.controller;

@safe:
import uim.servers;

class DSRVController {
  this() {}
  this(DSRVApi myApi) { this(); this.api(myApi); }

  mixin(SProperty!("DSRVApi", "api"));
  auto database() {
    if (api && api.server) return api.server.database;
    return null;
  }

  Json run(STRINGAA parameters) {
    auto json = Json.emptyObject;
    json["errors"] = Json.emptyArray;
    json["warnings"] = Json.emptyArray;
    json["infos"] = Json.emptyArray;
    json["result"] = Json.emptyObject;

    return json;
  }
}
auto SRVController() { return new DSRVController; }
auto SRVController(DSRVApi myApi) { return SRVController.api(myApi); }
