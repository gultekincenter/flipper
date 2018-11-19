type UNITS = 'KB'|'MB'|'GB'|'TB';

export function convertToBytes(value: number, unit: UNITS) {
    switch (unit) {
        case 'KB':
            return value * 1024;
        case 'MB':
            return value * Math.pow(1024, 2);
        case 'GB':
            return value * Math.pow(1024, 3);
        case 'TB':
            return value * Math.pow(1024, 4);
        default:
            return value;
    }
}
