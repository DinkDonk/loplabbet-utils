# loplabbet-utils

## Convert DOCX to CSV (for shoe carousell data source)

In the folder containing DOCX files run:

```bash
curl -L https://dinkdonk.github.io/loplabbet-utils/docx-to-csv.sh | bash /dev/stdin
```

This will result in a CSV file called `text.csv`.  
The delimiter is `|`, and the text qualifier is `"`.
