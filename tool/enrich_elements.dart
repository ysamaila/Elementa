// ignore_for_file: avoid_print
import 'dart:convert';
import 'dart:io';

// Accurate scientific dataset for all 118 IUPAC elements
final Map<int, Map<String, dynamic>> elementDetails = {
  1: {'config': '1s¹', 'state': 'Gas', 'mp': -259.16, 'bp': -252.87, 'density': 0.08988, 'en': 2.20, 'year': '1766', 'by': 'Henry Cavendish'},
  2: {'config': '1s²', 'state': 'Gas', 'mp': -272.20, 'bp': -268.93, 'density': 0.1786, 'en': null, 'year': '1868', 'by': 'Pierre Janssen & Norman Lockyer'},
  3: {'config': '[He] 2s¹', 'state': 'Solid', 'mp': 180.54, 'bp': 1342.0, 'density': 0.534, 'en': 0.98, 'year': '1817', 'by': 'Johan August Arfwedson'},
  4: {'config': '[He] 2s²', 'state': 'Solid', 'mp': 1287.0, 'bp': 2470.0, 'density': 1.85, 'en': 1.57, 'year': '1798', 'by': 'Louis-Nicolas Vauquelin'},
  5: {'config': '[He] 2s² 2p¹', 'state': 'Solid', 'mp': 2076.0, 'bp': 3927.0, 'density': 2.34, 'en': 2.04, 'year': '1808', 'by': 'J.L. Gay-Lussac & L.J. Thénard'},
  6: {'config': '[He] 2s² 2p²', 'state': 'Solid', 'mp': 3550.0, 'bp': 4027.0, 'density': 2.267, 'en': 2.55, 'year': 'Ancient', 'by': 'Ancient civilizations'},
  7: {'config': '[He] 2s² 2p³', 'state': 'Gas', 'mp': -210.0, 'bp': -195.79, 'density': 1.251, 'en': 3.04, 'year': '1772', 'by': 'Daniel Rutherford'},
  8: {'config': '[He] 2s² 2p⁴', 'state': 'Gas', 'mp': -218.79, 'bp': -182.96, 'density': 1.429, 'en': 3.44, 'year': '1774', 'by': 'Joseph Priestley & Carl Wilhelm Scheele'},
  9: {'config': '[He] 2s² 2p⁵', 'state': 'Gas', 'mp': -219.67, 'bp': -188.11, 'density': 1.696, 'en': 3.98, 'year': '1886', 'by': 'Henri Moissan'},
  10: {'config': '[He] 2s² 2p⁶', 'state': 'Gas', 'mp': -248.59, 'bp': -246.08, 'density': 0.9002, 'en': null, 'year': '1898', 'by': 'William Ramsay & Morris Travers'},
  11: {'config': '[Ne] 3s¹', 'state': 'Solid', 'mp': 97.72, 'bp': 883.0, 'density': 0.968, 'en': 0.93, 'year': '1807', 'by': 'Humphry Davy'},
  12: {'config': '[Ne] 3s²', 'state': 'Solid', 'mp': 650.0, 'bp': 1090.0, 'density': 1.738, 'en': 1.31, 'year': '1755', 'by': 'Joseph Black'},
  13: {'config': '[Ne] 3s² 3p¹', 'state': 'Solid', 'mp': 660.32, 'bp': 2470.0, 'density': 2.70, 'en': 1.61, 'year': '1825', 'by': 'Hans Christian Ørsted'},
  14: {'config': '[Ne] 3s² 3p²', 'state': 'Solid', 'mp': 1414.0, 'bp': 3265.0, 'density': 2.329, 'en': 1.90, 'year': '1824', 'by': 'Jöns Jacob Berzelius'},
  15: {'config': '[Ne] 3s² 3p³', 'state': 'Solid', 'mp': 44.15, 'bp': 280.5, 'density': 1.823, 'en': 2.19, 'year': '1669', 'by': 'Hennig Brand'},
  16: {'config': '[Ne] 3s² 3p⁴', 'state': 'Solid', 'mp': 115.21, 'bp': 444.6, 'density': 2.07, 'en': 2.58, 'year': 'Ancient', 'by': 'Ancient civilizations'},
  17: {'config': '[Ne] 3s² 3p⁵', 'state': 'Gas', 'mp': -101.5, 'bp': -34.04, 'density': 3.2, 'en': 3.16, 'year': '1774', 'by': 'Carl Wilhelm Scheele'},
  18: {'config': '[Ne] 3s² 3p⁶', 'state': 'Gas', 'mp': -189.34, 'bp': -185.85, 'density': 1.784, 'en': null, 'year': '1894', 'by': 'Lord Rayleigh & William Ramsay'},
  19: {'config': '[Ar] 4s¹', 'state': 'Solid', 'mp': 63.38, 'bp': 759.0, 'density': 0.862, 'en': 0.82, 'year': '1807', 'by': 'Humphry Davy'},
  20: {'config': '[Ar] 4s²', 'state': 'Solid', 'mp': 842.0, 'bp': 1484.0, 'density': 1.55, 'en': 1.00, 'year': '1808', 'by': 'Humphry Davy'},
  21: {'config': '[Ar] 3d¹ 4s²', 'state': 'Solid', 'mp': 1541.0, 'bp': 2836.0, 'density': 2.985, 'en': 1.36, 'year': '1879', 'by': 'Lars Fredrik Nilson'},
  22: {'config': '[Ar] 3d² 4s²', 'state': 'Solid', 'mp': 1668.0, 'bp': 3287.0, 'density': 4.506, 'en': 1.54, 'year': '1791', 'by': 'William Gregor'},
  23: {'config': '[Ar] 3d³ 4s²', 'state': 'Solid', 'mp': 1910.0, 'bp': 3407.0, 'density': 6.11, 'en': 1.63, 'year': '1801', 'by': 'Andrés Manuel del Río'},
  24: {'config': '[Ar] 3d⁵ 4s¹', 'state': 'Solid', 'mp': 1907.0, 'bp': 2671.0, 'density': 7.19, 'en': 1.66, 'year': '1797', 'by': 'Louis-Nicolas Vauquelin'},
  25: {'config': '[Ar] 3d⁵ 4s²', 'state': 'Solid', 'mp': 1246.0, 'bp': 2061.0, 'density': 7.21, 'en': 1.55, 'year': '1774', 'by': 'Carl Wilhelm Scheele & Johan Gottlieb Gahn'},
  26: {'config': '[Ar] 3d⁶ 4s²', 'state': 'Solid', 'mp': 1538.0, 'bp': 2862.0, 'density': 7.874, 'en': 1.83, 'year': 'Ancient', 'by': 'Ancient civilizations'},
  27: {'config': '[Ar] 3d⁷ 4s²', 'state': 'Solid', 'mp': 1495.0, 'bp': 2927.0, 'density': 8.90, 'en': 1.88, 'year': '1735', 'by': 'Georg Brandt'},
  28: {'config': '[Ar] 3d⁸ 4s²', 'state': 'Solid', 'mp': 1455.0, 'bp': 2730.0, 'density': 8.908, 'en': 1.91, 'year': '1751', 'by': 'Axel Fredrik Cronstedt'},
  29: {'config': '[Ar] 3d¹⁰ 4s¹', 'state': 'Solid', 'mp': 1084.62, 'bp': 2562.0, 'density': 8.96, 'en': 1.90, 'year': 'Ancient', 'by': 'Middle East'},
  30: {'config': '[Ar] 3d¹⁰ 4s²', 'state': 'Solid', 'mp': 419.53, 'bp': 907.0, 'density': 7.14, 'en': 1.65, 'year': 'Ancient', 'by': 'Indian metallurgists'},
  31: {'config': '[Ar] 3d¹⁰ 4s² 4p¹', 'state': 'Solid', 'mp': 29.76, 'bp': 2204.0, 'density': 5.91, 'en': 1.81, 'year': '1875', 'by': 'Paul-Émile Lecoq de Boisbaudran'},
  32: {'config': '[Ar] 3d¹⁰ 4s² 4p²', 'state': 'Solid', 'mp': 938.25, 'bp': 2833.0, 'density': 5.323, 'en': 2.01, 'year': '1886', 'by': 'Clemens Winkler'},
  33: {'config': '[Ar] 3d¹⁰ 4s² 4p³', 'state': 'Solid', 'mp': 817.0, 'bp': 614.0, 'density': 5.776, 'en': 2.18, 'year': 'Ancient', 'by': 'Albertus Magnus'},
  34: {'config': '[Ar] 3d¹⁰ 4s² 4p⁴', 'state': 'Solid', 'mp': 221.0, 'bp': 685.0, 'density': 4.819, 'en': 2.55, 'year': '1817', 'by': 'Jöns Jacob Berzelius'},
  35: {'config': '[Ar] 3d¹⁰ 4s² 4p⁵', 'state': 'Liquid', 'mp': -7.2, 'bp': 58.8, 'density': 3.1028, 'en': 2.96, 'year': '1826', 'by': 'Antoine Jérôme Balard'},
  36: {'config': '[Ar] 3d¹⁰ 4s² 4p⁶', 'state': 'Gas', 'mp': -157.36, 'bp': -153.22, 'density': 3.749, 'en': 3.00, 'year': '1898', 'by': 'William Ramsay & Morris Travers'},
  37: {'config': '[Kr] 5s¹', 'state': 'Solid', 'mp': 39.30, 'bp': 688.0, 'density': 1.532, 'en': 0.82, 'year': '1861', 'by': 'Robert Bunsen & Gustav Kirchhoff'},
  38: {'config': '[Kr] 5s²', 'state': 'Solid', 'mp': 777.0, 'bp': 1382.0, 'density': 2.64, 'en': 0.95, 'year': '1790', 'by': 'Adair Crawford'},
  39: {'config': '[Kr] 4d¹ 5s²', 'state': 'Solid', 'mp': 1526.0, 'bp': 3345.0, 'density': 4.472, 'en': 1.22, 'year': '1794', 'by': 'Johan Gadolin'},
  40: {'config': '[Kr] 4d² 5s²', 'state': 'Solid', 'mp': 1855.0, 'bp': 4409.0, 'density': 6.52, 'en': 1.33, 'year': '1789', 'by': 'Martin Heinrich Klaproth'},
  41: {'config': '[Kr] 4d⁴ 5s¹', 'state': 'Solid', 'mp': 2477.0, 'bp': 4744.0, 'density': 8.57, 'en': 1.6, 'year': '1801', 'by': 'Charles Hatchett'},
  42: {'config': '[Kr] 4d⁵ 5s¹', 'state': 'Solid', 'mp': 2623.0, 'bp': 4639.0, 'density': 10.28, 'en': 2.16, 'year': '1778', 'by': 'Carl Wilhelm Scheele'},
  43: {'config': '[Kr] 4d⁵ 5s²', 'state': 'Solid', 'mp': 2157.0, 'bp': 4265.0, 'density': 11.5, 'en': 1.9, 'year': '1937', 'by': 'Emilio Segrè & Carlo Perrier'},
  44: {'config': '[Kr] 4d⁷ 5s¹', 'state': 'Solid', 'mp': 2334.0, 'bp': 4150.0, 'density': 12.45, 'en': 2.2, 'year': '1844', 'by': 'Karl Ernst Claus'},
  45: {'config': '[Kr] 4d⁸ 5s¹', 'state': 'Solid', 'mp': 1964.0, 'bp': 3695.0, 'density': 12.41, 'en': 2.28, 'year': '1803', 'by': 'William Hyde Wollaston'},
  46: {'config': '[Kr] 4d¹⁰', 'state': 'Solid', 'mp': 1554.9, 'bp': 2963.0, 'density': 12.023, 'en': 2.20, 'year': '1803', 'by': 'William Hyde Wollaston'},
  47: {'config': '[Kr] 4d¹⁰ 5s¹', 'state': 'Solid', 'mp': 961.78, 'bp': 2162.0, 'density': 10.49, 'en': 1.93, 'year': 'Ancient', 'by': 'Ancient civilizations'},
  48: {'config': '[Kr] 4d¹⁰ 5s²', 'state': 'Solid', 'mp': 321.07, 'bp': 767.0, 'density': 8.65, 'en': 1.69, 'year': '1817', 'by': 'Karl Samuel Leberecht Hermann & Friedrich Stromeyer'},
  49: {'config': '[Kr] 4d¹⁰ 5s² 5p¹', 'state': 'Solid', 'mp': 156.6, 'bp': 2072.0, 'density': 7.31, 'en': 1.78, 'year': '1863', 'by': 'Ferdinand Reich & Hieronymous Theodor Richter'},
  50: {'config': '[Kr] 4d¹⁰ 5s² 5p²', 'state': 'Solid', 'mp': 231.93, 'bp': 2602.0, 'density': 7.287, 'en': 1.96, 'year': 'Ancient', 'by': 'Ancient civilizations'},
  51: {'config': '[Kr] 4d¹⁰ 5s² 5p³', 'state': 'Solid', 'mp': 630.63, 'bp': 1587.0, 'density': 6.697, 'en': 2.05, 'year': 'Ancient', 'by': 'Ancient civilizations'},
  52: {'config': '[Kr] 4d¹⁰ 5s² 5p⁴', 'state': 'Solid', 'mp': 449.51, 'bp': 988.0, 'density': 6.24, 'en': 2.1, 'year': '1782', 'by': 'Franz-Joseph Müller von Reichenstein'},
  53: {'config': '[Kr] 4d¹⁰ 5s² 5p⁵', 'state': 'Solid', 'mp': 113.7, 'bp': 184.3, 'density': 4.933, 'en': 2.66, 'year': '1811', 'by': 'Bernard Courtois'},
  54: {'config': '[Kr] 4d¹⁰ 5s² 5p⁶', 'state': 'Gas', 'mp': -111.7, 'bp': -108.12, 'density': 5.894, 'en': 2.6, 'year': '1898', 'by': 'William Ramsay & Morris Travers'},
  55: {'config': '[Xe] 6s¹', 'state': 'Solid', 'mp': 28.44, 'bp': 671.0, 'density': 1.93, 'en': 0.79, 'year': '1860', 'by': 'Robert Bunsen & Gustav Kirchhoff'},
  56: {'config': '[Xe] 6s²', 'state': 'Solid', 'mp': 727.0, 'bp': 1897.0, 'density': 3.51, 'en': 0.89, 'year': '1808', 'by': 'Humphry Davy'},
  57: {'config': '[Xe] 5d¹ 6s²', 'state': 'Solid', 'mp': 920.0, 'bp': 3464.0, 'density': 6.162, 'en': 1.10, 'year': '1839', 'by': 'Carl Gustaf Mosander'},
  58: {'config': '[Xe] 4f¹ 5d¹ 6s²', 'state': 'Solid', 'mp': 798.0, 'bp': 3443.0, 'density': 6.77, 'en': 1.12, 'year': '1803', 'by': 'Martin Heinrich Klaproth, Jöns Jacob Berzelius & Wilhelm Hisinger'},
  59: {'config': '[Xe] 4f³ 6s²', 'state': 'Solid', 'mp': 931.0, 'bp': 3520.0, 'density': 6.77, 'en': 1.13, 'year': '1885', 'by': 'Carl Auer von Welsbach'},
  60: {'config': '[Xe] 4f⁴ 6s²', 'state': 'Solid', 'mp': 1021.0, 'bp': 3074.0, 'density': 7.01, 'en': 1.14, 'year': '1885', 'by': 'Carl Auer von Welsbach'},
  61: {'config': '[Xe] 4f⁵ 6s²', 'state': 'Solid', 'mp': 1042.0, 'bp': 3000.0, 'density': 7.26, 'en': null, 'year': '1945', 'by': 'Chien Shiung Wu, Jacob A. Marinsky, Lawrence E. Glendenin & Charles D. Coryell'},
  62: {'config': '[Xe] 4f⁶ 6s²', 'state': 'Solid', 'mp': 1072.0, 'bp': 1794.0, 'density': 7.52, 'en': 1.17, 'year': '1879', 'by': 'Paul-Émile Lecoq de Boisbaudran'},
  63: {'config': '[Xe] 4f⁷ 6s²', 'state': 'Solid', 'mp': 822.0, 'bp': 1529.0, 'density': 5.244, 'en': null, 'year': '1896', 'by': 'Eugène-Anatole Demarçay'},
  64: {'config': '[Xe] 4f⁷ 5d¹ 6s²', 'state': 'Solid', 'mp': 1313.0, 'bp': 3273.0, 'density': 7.90, 'en': 1.20, 'year': '1880', 'by': 'Jean Charles Galissard de Marignac'},
  65: {'config': '[Xe] 4f⁹ 6s²', 'state': 'Solid', 'mp': 1356.0, 'bp': 3230.0, 'density': 8.23, 'en': null, 'year': '1843', 'by': 'Carl Gustaf Mosander'},
  66: {'config': '[Xe] 4f¹⁰ 6s²', 'state': 'Solid', 'mp': 1412.0, 'bp': 2567.0, 'density': 8.55, 'en': 1.22, 'year': '1886', 'by': 'Paul-Émile Lecoq de Boisbaudran'},
  67: {'config': '[Xe] 4f¹¹ 6s²', 'state': 'Solid', 'mp': 1474.0, 'bp': 2700.0, 'density': 8.79, 'en': 1.23, 'year': '1878', 'by': 'Marc Delafontaine & Jacques-Louis Soret'},
  68: {'config': '[Xe] 4f¹² 6s²', 'state': 'Solid', 'mp': 1529.0, 'bp': 2868.0, 'density': 9.066, 'en': 1.24, 'year': '1843', 'by': 'Carl Gustaf Mosander'},
  69: {'config': '[Xe] 4f¹³ 6s²', 'state': 'Solid', 'mp': 1545.0, 'bp': 1950.0, 'density': 9.32, 'en': 1.25, 'year': '1879', 'by': 'Per Teodor Cleve'},
  70: {'config': '[Xe] 4f¹⁴ 6s²', 'state': 'Solid', 'mp': 824.0, 'bp': 1196.0, 'density': 6.90, 'en': null, 'year': '1878', 'by': 'Jean Charles Galissard de Marignac'},
  71: {'config': '[Xe] 4f¹⁴ 5d¹ 6s²', 'state': 'Solid', 'mp': 1663.0, 'bp': 3402.0, 'density': 9.841, 'en': 1.27, 'year': '1907', 'by': 'Georges Urbain & Carl Auer von Welsbach'},
  72: {'config': '[Xe] 4f¹⁴ 5d² 6s²', 'state': 'Solid', 'mp': 2233.0, 'bp': 4603.0, 'density': 13.31, 'en': 1.3, 'year': '1923', 'by': 'Dirk Coster & George de Hevesy'},
  73: {'config': '[Xe] 4f¹⁴ 5d³ 6s²', 'state': 'Solid', 'mp': 3017.0, 'bp': 5458.0, 'density': 16.69, 'en': 1.5, 'year': '1802', 'by': 'Anders Gustaf Ekeberg'},
  74: {'config': '[Xe] 4f¹⁴ 5d⁴ 6s²', 'state': 'Solid', 'mp': 3422.0, 'bp': 5555.0, 'density': 19.25, 'en': 2.36, 'year': '1783', 'by': 'Carl Wilhelm Scheele & Fausto & Juan José Elhuyar'},
  75: {'config': '[Xe] 4f¹⁴ 5d⁵ 6s²', 'state': 'Solid', 'mp': 3186.0, 'bp': 5596.0, 'density': 21.02, 'en': 1.9, 'year': '1925', 'by': 'Masataka Ogawa, Walter Noddack, Ida Tacke & Otto Berg'},
  76: {'config': '[Xe] 4f¹⁴ 5d⁶ 6s²', 'state': 'Solid', 'mp': 3033.0, 'bp': 5012.0, 'density': 22.59, 'en': 2.2, 'year': '1803', 'by': 'Smithson Tennant'},
  77: {'config': '[Xe] 4f¹⁴ 5d⁷ 6s²', 'state': 'Solid', 'mp': 2446.0, 'bp': 4428.0, 'density': 22.56, 'en': 2.20, 'year': '1803', 'by': 'Smithson Tennant'},
  78: {'config': '[Xe] 4f¹⁴ 5d⁹ 6s¹', 'state': 'Solid', 'mp': 1768.3, 'bp': 3825.0, 'density': 21.45, 'en': 2.28, 'year': '1735', 'by': 'Antonio de Ulloa'},
  79: {'config': '[Xe] 4f¹⁴ 5d¹⁰ 6s¹', 'state': 'Solid', 'mp': 1064.18, 'bp': 2970.0, 'density': 19.30, 'en': 2.54, 'year': 'Ancient', 'by': 'Middle East'},
  80: {'config': '[Xe] 4f¹⁴ 5d¹⁰ 6s²', 'state': 'Liquid', 'mp': -38.83, 'bp': 356.73, 'density': 13.534, 'en': 2.00, 'year': 'Ancient', 'by': 'Ancient civilizations'},
  81: {'config': '[Xe] 4f¹⁴ 5d¹⁰ 6s² 6p¹', 'state': 'Solid', 'mp': 304.0, 'bp': 1473.0, 'density': 11.85, 'en': 1.62, 'year': '1861', 'by': 'William Crookes'},
  82: {'config': '[Xe] 4f¹⁴ 5d¹⁰ 6s² 6p²', 'state': 'Solid', 'mp': 327.46, 'bp': 1749.0, 'density': 11.34, 'en': 2.33, 'year': 'Ancient', 'by': 'Middle East'},
  83: {'config': '[Xe] 4f¹⁴ 5d¹⁰ 6s² 6p³', 'state': 'Solid', 'mp': 271.4, 'bp': 1564.0, 'density': 9.78, 'en': 2.02, 'year': '1753', 'by': 'Claude François Geoffroy'},
  84: {'config': '[Xe] 4f¹⁴ 5d¹⁰ 6s² 6p⁴', 'state': 'Solid', 'mp': 254.0, 'bp': 962.0, 'density': 9.196, 'en': 2.0, 'year': '1898', 'by': 'Pierre & Marie Curie'},
  85: {'config': '[Xe] 4f¹⁴ 5d¹⁰ 6s² 6p⁵', 'state': 'Solid', 'mp': 302.0, 'bp': 337.0, 'density': 6.35, 'en': 2.2, 'year': '1940', 'by': 'Dale R. Corson, Kenneth Ross MacKenzie & Emilio Segrè'},
  86: {'config': '[Xe] 4f¹⁴ 5d¹⁰ 6s² 6p⁶', 'state': 'Gas', 'mp': -71.0, 'bp': -61.7, 'density': 9.73, 'en': 2.2, 'year': '1899', 'by': 'Ernest Rutherford & Robert B. Owens'},
  87: {'config': '[Rn] 7s¹', 'state': 'Solid', 'mp': 27.0, 'bp': 677.0, 'density': 1.87, 'en': 0.7, 'year': '1939', 'by': 'Marguerite Perey'},
  88: {'config': '[Rn] 7s²', 'state': 'Solid', 'mp': 700.0, 'bp': 1737.0, 'density': 5.5, 'en': 0.9, 'year': '1898', 'by': 'Pierre & Marie Curie'},
  89: {'config': '[Rn] 6d¹ 7s²', 'state': 'Solid', 'mp': 1050.0, 'bp': 3198.0, 'density': 10.07, 'en': 1.1, 'year': '1899', 'by': 'André-Louis Debierne'},
  90: {'config': '[Rn] 6d² 7s²', 'state': 'Solid', 'mp': 1750.0, 'bp': 4788.0, 'density': 11.724, 'en': 1.3, 'year': '1829', 'by': 'Jöns Jacob Berzelius'},
  91: {'config': '[Rn] 5f² 6d¹ 7s²', 'state': 'Solid', 'mp': 1568.0, 'bp': 4027.0, 'density': 15.37, 'en': 1.5, 'year': '1913', 'by': 'Kasimir Fajans & Oswald Helmuth Göhring'},
  92: {'config': '[Rn] 5f³ 6d¹ 7s²', 'state': 'Solid', 'mp': 1132.2, 'bp': 4131.0, 'density': 19.1, 'en': 1.38, 'year': '1789', 'by': 'Martin Heinrich Klaproth'},
  93: {'config': '[Rn] 5f⁴ 6d¹ 7s²', 'state': 'Solid', 'mp': 644.0, 'bp': 4000.0, 'density': 20.45, 'en': 1.36, 'year': '1940', 'by': 'Edwin McMillan & Philip H. Abelson'},
  94: {'config': '[Rn] 5f⁶ 7s²', 'state': 'Solid', 'mp': 639.4, 'bp': 3228.0, 'density': 19.816, 'en': 1.28, 'year': '1940', 'by': 'Glenn T. Seaborg, Edwin McMillan, Joseph W. Kennedy & Arthur Wahl'},
  95: {'config': '[Rn] 5f⁷ 7s²', 'state': 'Solid', 'mp': 1176.0, 'bp': 2011.0, 'density': 12.0, 'en': 1.3, 'year': '1944', 'by': 'Glenn T. Seaborg, Ralph A. James, Leon O. Morgan & Albert Ghiorso'},
  96: {'config': '[Rn] 5f⁷ 6d¹ 7s²', 'state': 'Solid', 'mp': 1345.0, 'bp': 3110.0, 'density': 13.51, 'en': 1.3, 'year': '1944', 'by': 'Glenn T. Seaborg, Ralph A. James & Albert Ghiorso'},
  97: {'config': '[Rn] 5f⁹ 7s²', 'state': 'Solid', 'mp': 986.0, 'bp': 2627.0, 'density': 14.78, 'en': 1.3, 'year': '1949', 'by': 'Lawrence Berkeley National Laboratory'},
  98: {'config': '[Rn] 5f¹⁰ 7s²', 'state': 'Solid', 'mp': 900.0, 'bp': 1470.0, 'density': 15.1, 'en': 1.3, 'year': '1950', 'by': 'Lawrence Berkeley National Laboratory'},
  99: {'config': '[Rn] 5f¹¹ 7s²', 'state': 'Solid', 'mp': 860.0, 'bp': 996.0, 'density': 8.84, 'en': 1.3, 'year': '1952', 'by': 'Lawrence Berkeley National Laboratory'},
  100: {'config': '[Rn] 5f¹² 7s²', 'state': 'Solid', 'mp': 1527.0, 'bp': null, 'density': 9.7, 'en': 1.3, 'year': '1952', 'by': 'Lawrence Berkeley National Laboratory'},
  101: {'config': '[Rn] 5f¹³ 7s²', 'state': 'Solid', 'mp': 827.0, 'bp': null, 'density': 10.3, 'en': 1.3, 'year': '1955', 'by': 'Lawrence Berkeley National Laboratory'},
  102: {'config': '[Rn] 5f¹⁴ 7s²', 'state': 'Solid', 'mp': 827.0, 'bp': null, 'density': 9.9, 'en': 1.3, 'year': '1966', 'by': 'Joint Institute for Nuclear Research'},
  103: {'config': '[Rn] 5f¹⁴ 7s² 7p¹', 'state': 'Solid', 'mp': 1627.0, 'bp': null, 'density': 14.4, 'en': 1.3, 'year': '1961', 'by': 'Lawrence Berkeley National Laboratory'},
  104: {'config': '[Rn] 5f¹⁴ 6d² 7s²', 'state': 'Solid', 'mp': 2100.0, 'bp': 5500.0, 'density': 23.2, 'en': null, 'year': '1964', 'by': 'JINR & Lawrence Berkeley National Laboratory'},
  105: {'config': '[Rn] 5f¹⁴ 6d³ 7s²', 'state': 'Solid', 'mp': null, 'bp': null, 'density': 29.3, 'en': null, 'year': '1968', 'by': 'JINR & Lawrence Berkeley National Laboratory'},
  106: {'config': '[Rn] 5f¹⁴ 6d⁴ 7s²', 'state': 'Solid', 'mp': null, 'bp': null, 'density': 35.0, 'en': null, 'year': '1974', 'by': 'Lawrence Berkeley National Laboratory'},
  107: {'config': '[Rn] 5f¹⁴ 6d⁵ 7s²', 'state': 'Solid', 'mp': null, 'bp': null, 'density': 37.1, 'en': null, 'year': '1981', 'by': 'GSI Helmholtz Centre for Heavy Ion Research'},
  108: {'config': '[Rn] 5f¹⁴ 6d⁶ 7s²', 'state': 'Solid', 'mp': null, 'bp': null, 'density': 40.7, 'en': null, 'year': '1984', 'by': 'GSI Helmholtz Centre for Heavy Ion Research'},
  109: {'config': '[Rn] 5f¹⁴ 6d⁷ 7s²', 'state': 'Solid', 'mp': null, 'bp': null, 'density': 37.4, 'en': null, 'year': '1982', 'by': 'GSI Helmholtz Centre for Heavy Ion Research'},
  110: {'config': '[Rn] 5f¹⁴ 6d⁸ 7s²', 'state': 'Solid', 'mp': null, 'bp': null, 'density': 34.8, 'en': null, 'year': '1994', 'by': 'GSI Helmholtz Centre for Heavy Ion Research'},
  111: {'config': '[Rn] 5f¹⁴ 6d⁹ 7s²', 'state': 'Solid', 'mp': null, 'bp': null, 'density': 28.7, 'en': null, 'year': '1994', 'by': 'GSI Helmholtz Centre for Heavy Ion Research'},
  112: {'config': '[Rn] 5f¹⁴ 6d¹⁰ 7s²', 'state': 'Solid', 'mp': 10.0, 'bp': 67.0, 'density': 23.7, 'en': null, 'year': '1996', 'by': 'GSI Helmholtz Centre for Heavy Ion Research'},
  113: {'config': '[Rn] 5f¹⁴ 6d¹⁰ 7s² 7p¹', 'state': 'Solid', 'mp': 430.0, 'bp': 1130.0, 'density': 16.0, 'en': null, 'year': '2004', 'by': 'RIKEN (Japan)'},
  114: {'config': '[Rn] 5f¹⁴ 6d¹⁰ 7s² 7p²', 'state': 'Solid', 'mp': 67.0, 'bp': 150.0, 'density': 9.928, 'en': null, 'year': '1998', 'by': 'JINR & Lawrence Livermore National Laboratory'},
  115: {'config': '[Rn] 5f¹⁴ 6d¹⁰ 7s² 7p³', 'state': 'Solid', 'mp': 400.0, 'bp': 1100.0, 'density': 13.5, 'en': null, 'year': '2003', 'by': 'JINR & Lawrence Livermore National Laboratory'},
  116: {'config': '[Rn] 5f¹⁴ 6d¹⁰ 7s² 7p⁴', 'state': 'Solid', 'mp': 435.0, 'bp': 815.0, 'density': 12.9, 'en': null, 'year': '2000', 'by': 'JINR & Lawrence Livermore National Laboratory'},
  117: {'config': '[Rn] 5f¹⁴ 6d¹⁰ 7s² 7p⁵', 'state': 'Solid', 'mp': 450.0, 'bp': 610.0, 'density': 7.2, 'en': null, 'year': '2010', 'by': 'JINR & Oak Ridge National Laboratory'},
  118: {'config': '[Rn] 5f¹⁴ 6d¹⁰ 7s² 7p⁶', 'state': 'Solid', 'mp': 52.0, 'bp': 177.0, 'density': 5.0, 'en': null, 'year': '2002', 'by': 'JINR & Lawrence Livermore National Laboratory'},
};

void main() {
  final file = File('assets/data/elements.json');
  if (!file.existsSync()) {
    print('File not found: assets/data/elements.json');
    exit(1);
  }

  final rawJson = file.readAsStringSync();
  final List<dynamic> list = jsonDecode(rawJson);

  if (list.length != 118) {
    print('Error: expected 118 elements, got ${list.length}');
    exit(1);
  }

  for (final item in list) {
    final int number = item['number'];
    final details = elementDetails[number];
    if (details == null) {
      print('Missing details for element $number');
      exit(1);
    }

    item['electronConfiguration'] = details['config'];
    item['state'] = details['state'];
    item['meltingPoint'] = details['mp'];
    item['boilingPoint'] = details['bp'];
    item['density'] = details['density'];
    item['electronegativity'] = details['en'];
    item['discoveryYear'] = details['year'];
    item['discoveredBy'] = details['by'];
  }

  final encoder = JsonEncoder.withIndent('  ');
  file.writeAsStringSync(encoder.convert(list));
  print('Successfully enriched all 118 elements in assets/data/elements.json');
}
