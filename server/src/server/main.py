from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware
from fastapi.openapi.docs import get_swagger_ui_html
from fastapi.staticfiles import StaticFiles
from starlette.responses import HTMLResponse, RedirectResponse
from uvicorn import run

from server.core.logger import get_logger
from server.core.settings import settings

logger = get_logger("main")
app = FastAPI(
    debug=settings.debug,
    title=settings.title,
    version=settings.version,
    docs_url=None,
    redoc_url=None,
)
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_methods=["*"],
    allow_headers=["*"],
    allow_credentials=True,
)
app.mount("/static", StaticFiles(directory="static"), name="static")


@app.get("/", include_in_schema=False)
async def root() -> RedirectResponse:
    return RedirectResponse(url="/docs")


@app.get("/docs", include_in_schema=False)
async def swagger_ui_html() -> HTMLResponse:
    return get_swagger_ui_html(
        title=app.title,
        openapi_url=app.openapi_url,
        swagger_js_url="/static/swagger.js",
        swagger_css_url="/static/swagger.css",
        swagger_favicon_url="/static/favicon.svg",
    )


def main() -> None:  # pragma: no cover
    logger.info("Starting the server.")
    run("server.main:app")


if __name__ == "__main__":  # pragma: no cover
    main()
