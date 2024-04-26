from .models import Settings

def niab_settings():
    keys_values = Settings.objects.all()
    settings = {}
    for key_value in keys_values:
        settings[key_value.key] = key_value.value
    return settings
