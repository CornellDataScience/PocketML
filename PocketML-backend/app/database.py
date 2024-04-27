from sqlmodel import create_engine

from config import settings

engine = create_engine(str(settings.DATABASE_URL))
