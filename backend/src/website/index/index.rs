use handlebars::Handlebars;
use poem::handler;
use poem::web::{Data, Html};
use serde_json::json;

#[handler]
pub fn index(hbs: Data<&Handlebars>) -> Html<String> {
    Html(
        hbs.render(
            "website/index/templates/index.hbs",
            &json!({
              "title":"Postcard website",
              "debug": cfg!(debug_assertions)
            }),
        )
        .unwrap(),
    )
}
