# -*- coding: UTF-8 -*-
import xlrd
from connect_to_mongo import *

path = 'inversion.xlsx'

workbook = xlrd.open_workbook(path)
worksheet = workbook.sheet_by_index(0)

# Change this depending on how many header rows are present
# Set to 0 if you want to include the header data.
offset = 1

rows = []
for i, row in enumerate(range(worksheet.nrows)):
    if i <= offset:  # (Optionally) skip headers
        continue
    r = []

    for j, col in enumerate(range(worksheet.ncols)):
        r.append(worksheet.cell_value(i, j))
    rows.append(r)


for imp in rows:
    if imp[2] == 'Siria':
    # if imp[2][:4] == 'Hait':
        doc = {}
        doc['year'] = int(imp[0])
        doc['term'] = 'siria'
        doc['amount'] = int(imp[3])
        print(doc)
        insert_one_document('inversion', doc)