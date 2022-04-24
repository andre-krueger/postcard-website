use handlebars::Handlebars;
use poem::handler;
use poem::web::{Data, Html};
use serde_json::json;

#[handler]
pub fn admin_route(hbs: Data<&Handlebars>) -> Html<String> {
    Html(
        hbs.render(
            "admin/index/templates/index.html",
            &json!({"title":"Postcard website - Admin"}),
        )
        .unwrap(),
    )
}
