use handlebars::Handlebars;
use poem::endpoint::StaticFilesEndpoint;
use poem::middleware::AddData;
use poem::web::{Data, Html};
use poem::{get, handler, listener::TcpListener, EndpointExt, Route, Server};
use rust_embed::RustEmbed;
use serde_json::json;

#[handler]
fn home(hbs: Data<&Handlebars>) -> Html<String> {
    Html(
        hbs.render(
            "website/index.hbs",
            &json!({
              "title":"Postcard website",
              "debug": cfg!(debug_assertions)
            }),
        )
        .unwrap(),
    )
}

#[handler]
fn admin(hbs: Data<&Handlebars>) -> Html<String> {
    Html(
        hbs.render(
            "admin/index.html",
            &json!({"title":"Postcard website - Admin dashboard"}),
        )
        .unwrap(),
    )
}

#[derive(RustEmbed)]
#[folder = "static/"]
#[include = "*.{hbs,html}"]
struct Templates;

#[tokio::main]
async fn main() -> Result<(), std::io::Error> {
    let mut hbs = Handlebars::new();

    if cfg!(debug_assertions) {
        hbs.set_dev_mode(true);
        hbs.register_template_file("website/index.hbs", "./static/website/index.hbs")
            .unwrap();
        hbs.register_template_file("website/base.hbs", "./static/website/base.hbs")
            .unwrap();
        hbs.register_template_file("admin/index.html", "./static/admin/index.html")
            .unwrap();
    } else {
        hbs.register_embed_templates::<Templates>()
            .unwrap();
    }

    let mut app = Route::new()
        .at("/", get(home))
        .at("/admin", get(admin));

    if cfg!(debug_assertions) {
        app = app.nest("/static", StaticFilesEndpoint::new("static"));
    }

    Server::new(TcpListener::bind("0.0.0.0:8000"))
        .run(app.with(AddData::new(hbs)))
        .await
}
