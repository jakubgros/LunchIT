from configparser import ConfigParser


def get_config(section):
    file = "config.ini"
    parser = ConfigParser()
    parser.optionxform = str  # to preserve case sensitivity
    files_read = parser.read(file)
    if len(files_read) == 0:
        print("config.ini not found")
        exit(1)

    config = {}
    if parser.has_section(section):
        params = parser.items(section)
        for param in params:
            config[param[0]] = param[1]
    else:
        raise Exception('Section {0} not found in the {1} file'.format(section, file))

    return config
