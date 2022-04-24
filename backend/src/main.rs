use crate::admin::index::admin_route;
use crate::website::index::index::index;
use handlebars::Handlebars;
use poem::endpoint::StaticFilesEndpoint;
use poem::middleware::AddData;
use poem::{get, listener::TcpListener, EndpointExt, Route, Server};
use rust_embed::RustEmbed;

mod admin;
mod website;

#[derive(RustEmbed)]
#[folder = "templates/"]
#[include = "*.html"]
#[include = "*.hbs"]
struct Templates;

#[tokio::main]
async fn main() -> Result<(), std::io::Error> {
    let mut hbs = Handlebars::new();

    if cfg!(debug_assertions) {
        hbs.set_dev_mode(true);
        hbs.register_templates_directory("", "./static/templates")
            .unwrap();
    } else {
        hbs.register_embed_templates::<Templates>()
            .unwrap();
    }

    let mut app = Route::new()
        .at("/", get(index))
        .at("/admin", get(admin_route));

    if cfg!(debug_assertions) {
        app = app.nest("/static", StaticFilesEndpoint::new("static"));
    }

    Server::new(TcpListener::bind("0.0.0.0:8000"))
        .run(app.with(AddData::new(hbs)))
        .await
}
