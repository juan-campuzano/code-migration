"""
Configuration constants for the repository migration server.
"""

# LLM Model Configuration
DEFAULT_MODEL = "gpt-4"

# Timeout Configuration (in seconds)
MIGRATION_TIMEOUT_SECONDS = 300  # 5 minutes
DEFAULT_SESSION_TIMEOUT = 600  # 10 minutes
ANALYSIS_TIMEOUT = 60  # 1 minute

# Content Formatting
MAX_CHANGE_DESCRIPTION_LENGTH = 200  # characters
