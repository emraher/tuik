---
output: github_document
---

<!-- README.md is generated from README.Rmd. Please edit that file -->



# tuik

<!-- badges: start -->
[![Lifecycle: experimental](https://img.shields.io/badge/lifecycle-experimental-orange.svg)](https://www.tidyverse.org/lifecycle/#experimental)
<!-- badges: end -->

The goal of `tuik` is to extract data file and database urls from [TUIK](https://data.tuik.gov.tr/) webpage. Package can also download data from [Geographical Statistics Portal](https://cip.tuik.gov.tr/).

## Installation

You can install the development version from [GitHub](https://github.com/emraher/tuik) with:

``` r
# install.packages("devtools")
devtools::install_github("emraher/tuik")
```

## Example


```r
library(tuik)

(st <- statistical_themes())
#> # A tibble: 17 x 2
#>    theme_name                         theme_id
#>    <chr>                              <chr>   
#>  1 Adalet ve Seçim                    110     
#>  2 Bilim, Teknoloji ve Bilgi Toplumu  102     
#>  3 Çevre ve Enerji                    103     
#>  4 Dış Ticaret                        104     
#>  5 Eğitim, Kültür, Spor ve Turizm     105     
#>  6 Ekonomik Güven                     117     
#>  7 Enflasyon ve Fiyat                 106     
#>  8 Gelir, Yaşam, Tüketim ve Yoksulluk 107     
#>  9 İnşaat ve Konut                    116     
#> 10 İstihdam, İşsizlik ve Ücret        108     
#> 11 Nüfus ve Demografi                 109     
#> 12 Sağlık ve Sosyal Koruma            101     
#> 13 Sanayi                             114     
#> 14 Tarım                              111     
#> 15 Ticaret ve Hizmet                  115     
#> 16 Ulaştırma ve Haberleşme            112     
#> 17 Ulusal Hesaplar                    113

# stab <- statistical_tables("aaa")
#> Error in check_theme_id(theme) : 
#>  You should select a valid theme ID!

# stab <- statistical_tables(c(123, 143))
#> Error in check_theme_id(theme) : You can select only one theme!

(stab <- statistical_tables("110"))
#> # A tibble: 54 x 5
#>    theme_name   theme_id data_name                             data_date  datafile_url                               
#>    <chr>        <chr>    <chr>                                 <date>     <chr>                                      
#>  1 Adalet ve S… 110      Suç Türü ve Suçun İşlendiği Yaş Grub… 2020-11-02 http://data.tuik.gov.tr/Bulten/DownloadIst…
#>  2 Adalet ve S… 110      İBBS, 3. Düzeyde, Suç Türü ve Suçun … 2020-11-02 http://data.tuik.gov.tr/Bulten/DownloadIst…
#>  3 Adalet ve S… 110      Suç Türü ve Uyruğuna Göre Ceza İnfaz… 2020-11-02 http://data.tuik.gov.tr/Bulten/DownloadIst…
#>  4 Adalet ve S… 110      Suç Türü ve Medeni Durumuna Göre Cez… 2020-11-02 http://data.tuik.gov.tr/Bulten/DownloadIst…
#>  5 Adalet ve S… 110      Suç Türü ve Eğitim Durumuna Göre Cez… 2020-11-02 http://data.tuik.gov.tr/Bulten/DownloadIst…
#>  6 Adalet ve S… 110      İBBS 3. Düzeyde, Daimi İkametgah ve … 2020-11-02 http://data.tuik.gov.tr/Bulten/DownloadIst…
#>  7 Adalet ve S… 110      Hükümlü ve Tutuklu Sayısı             2020-11-02 http://data.tuik.gov.tr/Bulten/DownloadIst…
#>  8 Adalet ve S… 110      İBBS, 1. Düzeyde, Suç Türü ve Suçun … 2020-11-02 http://data.tuik.gov.tr/Bulten/DownloadIst…
#>  9 Adalet ve S… 110      Suç Türü ve Suçun İşlendiği Andaki Y… 2020-11-02 http://data.tuik.gov.tr/Bulten/DownloadIst…
#> 10 Adalet ve S… 110      Suç Türü ve Uyruğuna Göre Ceza İnfaz… 2020-11-02 http://data.tuik.gov.tr/Bulten/DownloadIst…
#> # … with 44 more rows

# sdb <- statistical_databases("aaa")
#> Error in check_theme_id(theme) : 
#>  You should select a valid theme ID!

# sdb <- statistical_databases(c(123, 143))
#> Error in check_theme_id(theme) : You can select only one theme!

(sdb <- statistical_databases(110))
#> # A tibble: 6 x 4
#>   theme_name     theme_id db_name                                           db_url                                   
#>   <chr>          <chr>    <chr>                                             <chr>                                    
#> 1 Adalet ve Seç… 110      "Milletvekili Seçim Sonuçları "                   http://biruni.tuik.gov.tr/secimdagitimap…
#> 2 Adalet ve Seç… 110      "Mahalli İdareler Seçim Sonuçları "               http://biruni.tuik.gov.tr/secimdagitimap…
#> 3 Adalet ve Seç… 110      "Cumhurbaşkanlığı Seçimi / Halk Oylaması Sonuçla… http://biruni.tuik.gov.tr/secimdagitimap…
#> 4 Adalet ve Seç… 110      "Ceza İnfaz Kurumuna Giren Hükümlü İstatistikler… http://biruni.tuik.gov.tr/girenhukumluap…
#> 5 Adalet ve Seç… 110      "Güvenlik Birimine Gelen veya Getirilen Çocuk İs… http://biruni.tuik.gov.tr/medas/?kn=98&l…
#> 6 Adalet ve Seç… 110      "Ceza İnfaz Kurumundan Çıkan (Tahliye Edilen) Hü… http://biruni.tuik.gov.tr/cikanhukumluap…


# -------------------------------------------------------------------------- ###
# All DB Links----
# -------------------------------------------------------------------------- ###
all_dbs <- purrr::map_df(.x = st$theme_id, .f = ~statistical_databases(.x))

all_dbs %>%
  dplyr::count(theme_name, name = "database_count")
#> # A tibble: 16 x 2
#>    theme_name                         database_count
#>    <chr>                                       <int>
#>  1 Adalet ve Seçim                                 6
#>  2 Bilim, Teknoloji ve Bilgi Toplumu               1
#>  3 Çevre ve Enerji                                 5
#>  4 Dış Ticaret                                     4
#>  5 Eğitim, Kültür, Spor ve Turizm                  7
#>  6 Ekonomik Güven                                  4
#>  7 Enflasyon ve Fiyat                              5
#>  8 Gelir, Yaşam, Tüketim ve Yoksulluk              3
#>  9 İnşaat ve Konut                                 8
#> 10 İstihdam, İşsizlik ve Ücret                     9
#> 11 Nüfus ve Demografi                             21
#> 12 Sanayi                                          9
#> 13 Tarım                                           9
#> 14 Ticaret ve Hizmet                               3
#> 15 Ulaştırma ve Haberleşme                         1
#> 16 Ulusal Hesaplar                                 3

# -------------------------------------------------------------------------- ###
# Download Geo Data----
# -------------------------------------------------------------------------- ###
# Download Variable Names and Codes
(dt <- geo_data())
#> # A tibble: 49 x 2
#>    variable_name                                    variable_no           
#>    <chr>                                            <chr>                 
#>  1 Atık Hizmeti Verilen Nüfus Oranı (%)             CVRBA-GK1697126-O40505
#>  2 Atıksu Arıtma Hizmeti Verilen Nüfus Oranı (%)    CVRAS-GK179211-O40717 
#>  3 Kişi Başı Günlük Atıksu Miktarı (L/Kişi-Gün)     CVRAS-GK179213-O40718 
#>  4 Kanalizasyon Hizmeti Verilen Nüfus Oranı (%)     CVRAS-GK179060-O40709 
#>  5 İçme Suyu Şebekesi Bulunan Nüfus Oranı (%)       CVRBS-GK1697172-O40909
#>  6 İçme Suyu Arıtma Hizmeti Verilen Nüfus Oranı (%) CVRBS-GK1697194-O40921
#>  7 Kişi Başına Elektrik Tüketimi (kWh)              ENR-GK054-O0015       
#>  8 Okuma Yazma Bilmeyen Sayısı                      ULE-GK160887-O29502   
#>  9 Sinema Salon Sayısı                              SNM-GK160947-O33301   
#> 10 Sinema Film Sayısı                               SNM-GK160951-O33303   
#> # … with 39 more rows

# dt <- geo_data(5)
#> Error in geo_data(5) : There's no IBBS at this level!

# Download data for a given level and variable
(dt <- geo_data(2, "SNM-GK160951-O33303"))
#> New names:
#> * `` -> ...1
#> * `` -> ...2
#> * `` -> ...3
#> * `` -> ...4
#> * `` -> ...5
#> New names:
#> * `` -> ...1
#> * `` -> ...2
#> * `` -> ...3
#> * `` -> ...4
#> * `` -> ...5
#> New names:
#> * `` -> ...1
#> * `` -> ...2
#> * `` -> ...3
#> * `` -> ...4
#> * `` -> ...5
#> New names:
#> * `` -> ...1
#> * `` -> ...2
#> * `` -> ...3
#> * `` -> ...4
#> * `` -> ...5
#> New names:
#> * `` -> ...1
#> * `` -> ...2
#> * `` -> ...3
#> * `` -> ...4
#> * `` -> ...5
#> New names:
#> * `` -> ...1
#> * `` -> ...2
#> * `` -> ...3
#> * `` -> ...4
#> * `` -> ...5
#> New names:
#> * `` -> ...1
#> * `` -> ...2
#> * `` -> ...3
#> * `` -> ...4
#> * `` -> ...5
#> New names:
#> * `` -> ...1
#> * `` -> ...2
#> * `` -> ...3
#> * `` -> ...4
#> * `` -> ...5
#> New names:
#> * `` -> ...1
#> * `` -> ...2
#> * `` -> ...3
#> * `` -> ...4
#> * `` -> ...5
#> New names:
#> * `` -> ...1
#> * `` -> ...2
#> * `` -> ...3
#> * `` -> ...4
#> * `` -> ...5
#> New names:
#> * `` -> ...1
#> * `` -> ...2
#> * `` -> ...3
#> * `` -> ...4
#> * `` -> ...5
#> New names:
#> * `` -> ...1
#> * `` -> ...2
#> * `` -> ...3
#> * `` -> ...4
#> * `` -> ...5
#> New names:
#> * `` -> ...1
#> * `` -> ...2
#> * `` -> ...3
#> * `` -> ...4
#> * `` -> ...5
#> New names:
#> * `` -> ...1
#> * `` -> ...2
#> * `` -> ...3
#> * `` -> ...4
#> * `` -> ...5
#> New names:
#> * `` -> ...1
#> * `` -> ...2
#> * `` -> ...3
#> * `` -> ...4
#> * `` -> ...5
#> New names:
#> * `` -> ...1
#> * `` -> ...2
#> * `` -> ...3
#> * `` -> ...4
#> * `` -> ...5
#> New names:
#> * `` -> ...1
#> * `` -> ...2
#> * `` -> ...3
#> * `` -> ...4
#> * `` -> ...5
#> New names:
#> * `` -> ...1
#> * `` -> ...2
#> * `` -> ...3
#> * `` -> ...4
#> * `` -> ...5
#> New names:
#> * `` -> ...1
#> * `` -> ...2
#> * `` -> ...3
#> * `` -> ...4
#> * `` -> ...5
#> New names:
#> * `` -> ...1
#> * `` -> ...2
#> * `` -> ...3
#> * `` -> ...4
#> * `` -> ...5
#> New names:
#> * `` -> ...1
#> * `` -> ...2
#> * `` -> ...3
#> * `` -> ...4
#> * `` -> ...5
#> New names:
#> * `` -> ...1
#> * `` -> ...2
#> * `` -> ...3
#> * `` -> ...4
#> * `` -> ...5
#> New names:
#> * `` -> ...1
#> * `` -> ...2
#> * `` -> ...3
#> * `` -> ...4
#> * `` -> ...5
#> New names:
#> * `` -> ...1
#> * `` -> ...2
#> * `` -> ...3
#> * `` -> ...4
#> * `` -> ...5
#> New names:
#> * `` -> ...1
#> * `` -> ...2
#> * `` -> ...3
#> * `` -> ...4
#> * `` -> ...5
#> New names:
#> * `` -> ...1
#> * `` -> ...2
#> * `` -> ...3
#> * `` -> ...4
#> * `` -> ...5
#> # A tibble: 130 x 3
#>    code  date  sinema_film_sayisi
#>    <chr> <chr>              <dbl>
#>  1 TR83  2019                1838
#>  2 TR83  2018                1568
#>  3 TR83  2017                1577
#>  4 TR83  2016                1284
#>  5 TR83  2015                1656
#>  6 TR72  2019                1647
#>  7 TR72  2018                1561
#>  8 TR72  2017                1318
#>  9 TR72  2016                 962
#> 10 TR72  2015                1035
#> # … with 120 more rows

# (dt <- geo_data(4, "TFE-GK105747-O23001"))
#> Error in value[[3L]](cond) : 
#>  This data (TFE-GK105747-O23001) is not available at this NUTS level (level = 4)!!!
```


