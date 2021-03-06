module uim.servers.sessions.session;

@safe:
import uim.servers;

class DSRVSession {
  this(Session httpSession) {
    _httpSession = httpSession;
    this.id(httpSession.id);
  }

  mixin(SProperty!("string", "id"));
  Session _httpSession;

  mixin(SProperty!("long", "lastAccessedOn"));
  mixin(SProperty!("DOOPEntity", "login"));
  mixin(SProperty!("DOOPEntity", "session"));
  mixin(SProperty!("DOOPEntity", "site"));
  mixin(SProperty!("DOOPEntity", "account"));
  mixin(SProperty!("DOOPEntity", "user"));
  mixin(SProperty!("DOOPEntity", "password"));
  mixin(SProperty!("DOOPEntity", "entity"));

  bool valid(string[] factors) {
    foreach(factor; factors) 
      switch(factor) {
        case "login": if (login is null) return false; break;
        case "session": if (session is null) return false; break;
        case "site": if (site is null) return false; break;
        case "account": if (account is null) return false; break;
        case "user": if (user is null) return false; break;
        default: break;
      }
    return true;
  }
}
auto SRVSession(Session httpSession) { return new DSRVSession(httpSession); }

