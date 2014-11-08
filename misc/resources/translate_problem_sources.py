import jeolm.local, jeolm.commands
from jeolm.record_path import RecordPath

def main(from_path, to_path, translations, *, driver, local):
    translated_sources = {}
    for metapath, metarecord in driver.items(from_path):
        if '$problem-source' not in metarecord:
            continue
        to_metapath = RecordPath(to_path, *metapath.parts[len(from_path.parts):])
        if '$problem-source' in driver[to_metapath]:
            raise RuntimeError(to_metapath)
        to_inpath = local.source_dir / to_metapath.as_inpath(suffix='.tex')
        translated_sources[to_inpath] = translations[metarecord['$problem-source']]
    for to_inpath, translated_source in translated_sources.items():
        with open(str(to_inpath), 'a') as f:
            f.write('% $problem-source: {}\n'.format(translated_source))

if __name__ == '__main__':
    local = jeolm.local.LocalManager()
    driver = jeolm.commands.simple_load_driver(local)
    import sys
    from_record_path, to_record_path, translations_path = sys.argv[1:]
    from_record_path = RecordPath(from_record_path)
    to_record_path = RecordPath(to_record_path)
    translations = {}
    with open(translations_path, 'r') as f:
        for line in f.readlines():
            line = line.strip()
            if '\t' in line:
                from_s, to_s = line.split('\t')
            else:
                from_s = to_s = line
            translations[from_s] = to_s
    main(from_record_path, to_record_path, translations, driver=driver, local=local)




