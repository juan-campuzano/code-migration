# Python Migration Instructions

## Detection
- **Config files:** `requirements.txt`, `pyproject.toml`, `Pipfile`, `setup.py`, `setup.cfg`
- **Version manager:** `pyenv` (`.python-version`), `conda`, `asdf`

## Framework Detection

| Package | Framework |
|---------|-----------|
| `django` | Django |
| `fastapi` | FastAPI |
| `flask` | Flask |
| `starlette` | Starlette |
| `tornado` | Tornado |
| `aiohttp` | aiohttp |
| `celery` | Celery |
| `sqlalchemy` | SQLAlchemy |

## Package Manager Detection

| File | Manager | Commands |
|------|---------|----------|
| `requirements.txt` | pip | `pip install -r requirements.txt` |
| `pyproject.toml` (with `[tool.poetry]`) | poetry | `poetry install` |
| `pyproject.toml` (with `[project]`) | pip / uv | `pip install .` or `uv sync` |
| `Pipfile` | pipenv | `pipenv install` |
| `setup.py` | pip | `pip install -e .` |

## Commands Reference

### pip
| Action | Command |
|--------|---------|
| Install | `pip install -r requirements.txt` |
| Check outdated | `pip list --outdated` |
| Upgrade all | `pip install -U -r requirements.txt` |
| Audit | `pip-audit` or `safety check` |
| Freeze | `pip freeze > requirements.txt` |

### poetry
| Action | Command |
|--------|---------|
| Install | `poetry install` |
| Check outdated | `poetry show --outdated` |
| Update | `poetry update` |
| Add package | `poetry add [package]@latest` |
| Audit | `poetry audit` (with plugin) |

### uv
| Action | Command |
|--------|---------|
| Install | `uv sync` |
| Check outdated | `uv pip list --outdated` |
| Update | `uv lock --upgrade` |
| Add package | `uv add [package]` |

## Linting and Analysis

| Tool | Command |
|------|---------|
| ruff | `ruff check .` (lint), `ruff format .` (format) |
| mypy | `mypy .` (type checking) |
| pylint | `pylint [package]` |
| flake8 | `flake8 .` |
| black | `black .` (formatting) |
| isort | `isort .` (import sorting) |
| bandit | `bandit -r .` (security) |

## Testing

| Tool | Command |
|------|---------|
| pytest | `pytest -v` |
| pytest coverage | `pytest --cov=[package] --cov-report=html` |
| unittest | `python -m unittest discover` |
| tox | `tox` |
| nox | `nox` |

## Common Breaking Changes

### Python 3.11 → 3.12
- `distutils` removed (use `setuptools`)
- `asyncio.coroutine` removed
- `typing.TypeVar` changes
- `imp` module removed
- `locale.getdefaultlocale()` removed

### Python 3.12 → 3.13
- Experimental free-threaded build
- `typing` deprecations
- New REPL
- `aifc`, `audioop`, `cgi`, `cgitb`, `chunk`, `crypt`, etc. removed

### Django 4.x → 5.x
- Python 3.10+ required
- `DEFAULT_FILE_STORAGE` → `STORAGES["default"]`
- `STATICFILES_STORAGE` → `STORAGES["staticfiles"]`
- `Field.choices` accepts callables
- Form field rendering changes

### FastAPI 0.100+
- Pydantic v2 required
- `from pydantic import BaseSettings` → `from pydantic_settings import BaseSettings`
- `.dict()` → `.model_dump()`
- `.parse_obj()` → `.model_validate()`
- `schema_extra` → `json_schema_extra`

### SQLAlchemy 1.4 → 2.0
- `session.query()` → `select()` statements
- `Session.execute()` returns `Result`
- Typing support overhaul
- `declarative_base()` → `DeclarativeBase`

### Pydantic v1 → v2
```python
# Before (v1)
class Model(BaseModel):
    class Config:
        orm_mode = True
    
    name: str = Field(..., regex=r"^[a-z]+$")

# After (v2)
class Model(BaseModel):
    model_config = ConfigDict(from_attributes=True)
    
    name: str = Field(..., pattern=r"^[a-z]+$")
```

## Codemods and Auto-fixers

| Migration | Tool |
|-----------|------|
| Pydantic v1→v2 | `bump-pydantic .` |
| Django upgrades | `django-upgrade --target-version [ver] [files]` |
| pyupgrade | `pyupgrade --py3[X]-plus [files]` |
| ruff fixes | `ruff check --fix .` |
| SQLAlchemy 2.0 | Manual migration with `sa.select()` pattern |

## pyproject.toml Modern Template

```toml
[project]
name = "my-project"
version = "1.0.0"
requires-python = ">=3.12"
dependencies = [...]

[tool.ruff]
target-version = "py312"
line-length = 88

[tool.ruff.lint]
select = ["E", "F", "I", "N", "W", "UP"]

[tool.mypy]
python_version = "3.12"
strict = true

[tool.pytest.ini_options]
testpaths = ["tests"]
```
