# 環境構築
## 1. MySQLの設定
- ユーザーを作成
```
mysql> create user 'xxxxx'@'localhost' identified by 'xxxxxxxx';
```
- ユーザーが作成されているかを確認
```
mysql>select User,Host from mysql.user;
```
- 作成したユーザーに権限を設定
```
mysql> grant all on *.* to 'xxxxx'@'localhost';
```

### 参考
- [【Rails】【DB】database.yml](https://qiita.com/ryouya3948/items/ba3012ba88d9ea8fd43d)
- [【MySQL入門】MySQLの起動・停止・再起動 基礎的なコマンドまとめ](https://style.potepan.com/articles/18698.html)

## ２. mimemagic (0.3.5)
- mimemagic (0.3.5)が公開停止となったため、次のエラーが出た。

```
$ bundle
The dependency tzinfo-data (>= 0) will be unused by any of the platforms Bundler is installing for. Bundler is installing for ruby but the dependency is only for x86-mingw32, x86-mswin32, x64-mingw32, java. To add those platforms to the bundle, run `bundle lock --add-platform x86-mingw32 x86-mswin32 x64-mingw32 java`.
Fetching gem metadata from https://rubygems.org/..........
Your bundle is locked to mimemagic (0.3.5), but that version could not be found in any of the sources listed in your Gemfile. If you haven't changed sources, that means the author of mimemagic (0.3.5) has
removed it. You'll need to update your bundle to a version other than mimemagic (0.3.5) that hasn't been removed in order to install.
```
### 解決手順
- 次のコマンドを実行
```
$ bundle update mimemagic
```
### 参考
- [[Rails] bundle installがYour bundle is locked to mimemagic (0.3.5)...で落ちる](https://qiita.com/Wacci6/items/dc6ffec9b50578d44d6c)

## 3.Git Large File Storage
- 大容量ファイルを管理するためのGitの拡張機能
- 100.00 MBを超えるとGitから次のような警告が出される。
```
$ git push origin master
remote: error: File db/seed.sql is 168.10 MB; this exceeds GitHub's file size limit of 100.00 MB
remote: error: GH001: Large files detected. You may want to try Git Large File Storage - https://git-lfs.github.com.
```
### 解決手順
- Homebrewを使って、次のコマンドを実行。
```
$ brew install git-lfs
```
- 次のコマンドを実行
```
$ git lfs install
Updated Git hooks.
Git LFS initialized.
```
- 管理するファイルを設定
  - 今回は、`.sql`を管理したいので、`"*.sql"`を追加
```
$ git lfs track "*.sql"
Tracking "*.sql"
```
### 参考
- [画像を含めると1GB以上あったので、Git Large File Storageを使ってみた](https://satoyan419.com/git-large-file-storage/)

# 課題
## (例題) first_nameがGeorgi, last_nameがFacelloの従業員を取得してください
```
irb(main):001:0> Employee.where(first_name: "Georgi", last_name: "Facello")
   (3.7ms)  SET NAMES utf8mb4,  @@SESSION.sql_mode = CONCAT(CONCAT(@@sql_mode, ',STRICT_ALL_TABLES'), ',NO_AUTO_VALUE_ON_ZERO'),  @@SESSION.sql_auto_is_null = 0, @@SESSION.wait_timeout = 2147483
  Employee Load (320.6ms)  SELECT `employees`.* FROM `employees` WHERE `employees`.`first_name` = 'Georgi' AND `employees`.`last_name` = 'Facello'
+--------+------------+------------+-----------+--------+------------+
| emp_no | birth_date | first_name | last_name | gender | hire_date  |
+--------+------------+------------+-----------+--------+------------+
| 10001  | 1953-09-02 | Georgi     | Facello   | M      | 1986-06-26 |
| 55649  | 1956-01-23 | Georgi     | Facello   | M      | 1988-05-04 |
+--------+------------+------------+-----------+--------+------------+
2 rows in set
```

## 1.従業員番号が499999の従業員の給料全てを取得してください
```
irb(main):003:0> Salary.where(emp_no: "499999")
  Salary Load (6.2ms)  SELECT `salaries`.* FROM `salaries` WHERE `salaries`.`emp_no` = 499999
+--------+--------+------------+------------+
| emp_no | salary | from_date  | to_date    |
+--------+--------+------------+------------+
| 499999 | 63707  | 1997-11-30 | 1998-11-30 |
| 499999 | 67043  | 1998-11-30 | 1999-11-30 |
| 499999 | 70745  | 1999-11-30 | 2000-11-29 |
| 499999 | 74327  | 2000-11-29 | 2001-11-29 |
| 499999 | 77303  | 2001-11-29 | 9999-01-01 |
+--------+--------+------------+------------+
5 rows in set
```
## 2.従業員番号が499999の従業員の2001-01-01時点の給料を取得してください
```
irb(main):018:0> salary = Salary.where(emp_no: "499999")
  Salary Load (31.0ms)  SELECT `salaries`.* FROM `salaries` WHERE `salaries`.`emp_no` = 499999
+--------+--------+------------+------------+
| emp_no | salary | from_date  | to_date    |
+--------+--------+------------+------------+
| 499999 | 63707  | 1997-11-30 | 1998-11-30 |
| 499999 | 67043  | 1998-11-30 | 1999-11-30 |
| 499999 | 70745  | 1999-11-30 | 2000-11-29 |
| 499999 | 74327  | 2000-11-29 | 2001-11-29 |
| 499999 | 77303  | 2001-11-29 | 9999-01-01 |
+--------+--------+------------+------------+
```
```
irb(main):033:0> salary.where("to_date >= ?","2001-01-01")
  Salary Load (0.9ms)  SELECT `salaries`.* FROM `salaries` WHERE `salaries`.`emp_no` = 499999 AND `salaries`.`to_date` >= '2001-01-01' AND (to_date >= '2001-01-01')
+--------+--------+------------+------------+
| emp_no | salary | from_date  | to_date    |
+--------+--------+------------+------------+
| 499999 | 74327  | 2000-11-29 | 2001-11-29 |
| 499999 | 77303  | 2001-11-29 | 9999-01-01 |
+--------+--------+------------+------------+
2 rows in set

```
irb(main):032:0> salary.where("from_date <= ?", "2001-01-01")
  Salary Load (6.2ms)  SELECT `salaries`.* FROM `salaries` WHERE `salaries`.`emp_no` = 499999 AND `salaries`.`to_date` >= '2001-01-01' AND (from_date <= '2001-01-01')
+--------+--------+------------+------------+
| emp_no | salary | from_date  | to_date    |
+--------+--------+------------+------------+
| 499999 | 74327  | 2000-11-29 | 2001-11-29 |
+--------+--------+------------+------------+
1 row in set
```

- ワンライナー
```
irb(main):035:0> Salary.where(emp_no: "499999").where("from_date <= ?", "2001-01-01").where("to_date >= ?","2001-01-01")
  Salary Load (0.6ms)  SELECT `salaries`.* FROM `salaries` WHERE `salaries`.`emp_no` = 499999 AND (from_date <= '2001-01-01') AND (to_date >= '2001-01-01')
+--------+--------+------------+------------+
| emp_no | salary | from_date  | to_date    |
+--------+--------+------------+------------+
| 499999 | 74327  | 2000-11-29 | 2001-11-29 |
+--------+--------+------------+------------+
1 row in set
```
## 3.150000以上の給料をもらったことがある従業員の一覧を取得してください
```
irb(main):010:0> Salary.joins(:employee).select("employees.emp_no","employees.birth_date","employees.first_name","employees.last_name","employees.gender","employees.hire_date").where(salary: 150000...).distinct
  Salary Load (1615.2ms)  SELECT DISTINCT employees.emp_no, employees.birth_date, employees.first_name, employees.last_name, employees.gender, employees.hire_date FROM `salaries` INNER JOIN `employees` ON `employees`.`emp_no` = `salaries`.`emp_no` WHERE `salaries`.`salary` >= 150000
+--------+------------+------------+-----------+--------+------------+
| emp_no | birth_date | first_name | last_name | gender | hire_date  |
+--------+------------+------------+-----------+--------+------------+
| 43624  | 1953-11-14 | Tokuyasu   | Pesch     | M      | 1985-03-26 |
| 46439  | 1953-01-31 | Ibibia     | Junet     | M      | 1985-05-20 |
| 47978  | 1956-03-24 | Xiahua     | Whitcomb  | M      | 1985-07-18 |
| 66793  | 1964-05-15 | Lansing    | Kambil    | M      | 1985-06-20 |
| 80823  | 1963-01-21 | Willard    | Baca      | M      | 1985-02-26 |
| 109334 | 1955-08-02 | Tsutomu    | Alameldin | M      | 1985-02-15 |
| 205000 | 1956-01-14 | Charmane   | Griswold  | M      | 1990-06-23 |
| 237542 | 1954-10-05 | Weicheng   | Hatcliff  | F      | 1985-04-12 |
| 238117 | 1959-06-21 | Mitsuyuki  | Stanfel   | M      | 1988-01-03 |
| 253939 | 1957-12-03 | Sanjai     | Luders    | M      | 1987-04-15 |
| 254466 | 1963-05-27 | Honesty    | Mukaidono | M      | 1986-08-08 |
| 266526 | 1957-02-14 | Weijing    | Chenoweth | F      | 1986-10-08 |
| 276633 | 1954-01-27 | Shin       | Birdsall  | M      | 1987-10-08 |
| 279776 | 1955-05-06 | Mohammed   | Moehrke   | M      | 1986-06-10 |
| 493158 | 1961-05-20 | Lidong     | Meriste   | M      | 1987-05-09 |
+--------+------------+------------+-----------+--------+------------+
15 rows in set
```
- 正規表現を使って、リファクタリング
```
Salary.joins(:employee).select("employees.*").where(salary: 150000...).distinct
  Salary Load (1595.2ms)  SELECT DISTINCT employees.* FROM `salaries` INNER JOIN `employees` ON `employees`.`emp_no` = `salaries`.`emp_no` WHERE `salaries`.`salary` >= 150000
+--------+------------+------------+-----------+--------+------------+
| emp_no | birth_date | first_name | last_name | gender | hire_date  |
+--------+------------+------------+-----------+--------+------------+
| 43624  | 1953-11-14 | Tokuyasu   | Pesch     | M      | 1985-03-26 |
| 46439  | 1953-01-31 | Ibibia     | Junet     | M      | 1985-05-20 |
| 47978  | 1956-03-24 | Xiahua     | Whitcomb  | M      | 1985-07-18 |
| 66793  | 1964-05-15 | Lansing    | Kambil    | M      | 1985-06-20 |
| 80823  | 1963-01-21 | Willard    | Baca      | M      | 1985-02-26 |
| 109334 | 1955-08-02 | Tsutomu    | Alameldin | M      | 1985-02-15 |
| 205000 | 1956-01-14 | Charmane   | Griswold  | M      | 1990-06-23 |
| 237542 | 1954-10-05 | Weicheng   | Hatcliff  | F      | 1985-04-12 |
| 238117 | 1959-06-21 | Mitsuyuki  | Stanfel   | M      | 1988-01-03 |
| 253939 | 1957-12-03 | Sanjai     | Luders    | M      | 1987-04-15 |
| 254466 | 1963-05-27 | Honesty    | Mukaidono | M      | 1986-08-08 |
| 266526 | 1957-02-14 | Weijing    | Chenoweth | F      | 1986-10-08 |
| 276633 | 1954-01-27 | Shin       | Birdsall  | M      | 1987-10-08 |
| 279776 | 1955-05-06 | Mohammed   | Moehrke   | M      | 1986-06-10 |
| 493158 | 1961-05-20 | Lidong     | Meriste   | M      | 1987-05-09 |
+--------+------------+------------+-----------+--------+------------+
15 rows in set
```

## 4.150000以上の給料をもらったことがある女性従業員の一覧を取得してください
```
irb(main):015:0> Salary.joins(:employee).select("employees.emp_no","employees.birth_date","employees.first_name","employees.last_name","employees.gender","employees.hire_date").where(salary: 150000...).distinct.where(employees: {gender: "F"})
  Salary Load (1396.6ms)  SELECT DISTINCT employees.emp_no, employees.birth_date, employees.first_name, employees.last_name, employees.gender, employees.hire_date FROM `salaries` INNER JOIN `employees` ON `employees`.`emp_no` = `salaries`.`emp_no` WHERE `salaries`.`salary` >= 150000 AND `employees`.`gender` = 'F'
+--------+------------+------------+-----------+--------+------------+
| emp_no | birth_date | first_name | last_name | gender | hire_date  |
+--------+------------+------------+-----------+--------+------------+
| 237542 | 1954-10-05 | Weicheng   | Hatcliff  | F      | 1985-04-12 |
| 266526 | 1957-02-14 | Weijing    | Chenoweth | F      | 1986-10-08 |
+--------+------------+------------+-----------+--------+------------+
2 rows in set
```
- 正規表現を使ってリファクタリング
```
Salary.joins(:employee).select("employees.*").where(salary: 150000...).distinct.where(employees: {gender: "F"})
  Salary Load (709.3ms)  SELECT DISTINCT employees.* FROM `salaries` INNER JOIN `employees` ON `employees`.`emp_no` = `salaries`.`emp_no` WHERE `salaries`.`salary` >= 150000 AND `employees`.`gender` = 'F'
+--------+------------+------------+-----------+--------+------------+
| emp_no | birth_date | first_name | last_name | gender | hire_date  |
+--------+------------+------------+-----------+--------+------------+
| 237542 | 1954-10-05 | Weicheng   | Hatcliff  | F      | 1985-04-12 |
| 266526 | 1957-02-14 | Weijing    | Chenoweth | F      | 1986-10-08 |
+--------+------------+------------+-----------+--------+------------+
2 rows in set
```

## 5.どんな肩書きがあるか一覧で取得してきてください
```irb(main):001:0> Title.select(:title).distinct
   (7.2ms)  SET NAMES utf8mb4,  @@SESSION.sql_mode = CONCAT(CONCAT(@@sql_mode, ',STRICT_ALL_TABLES'), ',NO_AUTO_VALUE_ON_ZERO'),  @@SESSION.sql_auto_is_null = 0, @@SESSION.wait_timeout = 2147483
  Title Load (1296.1ms)  SELECT DISTINCT `titles`.`title` FROM `titles`
+--------------------+
| title              |
+--------------------+
| Senior Engineer    |
| Staff              |
| Engineer           |
| Senior Staff       |
| Assistant Engineer |
| Technique Leader   |
| Manager            |
+--------------------+
7 rows in set
```

## 6.2000-1-29以降に肩書きが「Technique Leader」になった従業員を取得してください
```
irb(main):005:0>Title.joins(:employee).select("employees.emp_no","employees.birth_date","employees.first_name","employees.last_name","employees.gender","employees.hire_date").where(title: "Technique Leader").where(from_date: "2000-1-29"..)
  Title Load (919.1ms)  SELECT employees.emp_no, employees.birth_date, employees.first_name, employees.last_name, employees.gender, employees.hire_date FROM `titles` INNER JOIN `employees` ON `employees`.`emp_no` = `titles`.`emp_no` WHERE `titles`.`title` = 'Technique Leader' AND `titles`.`from_date` >= '2000-01-29'
+--------+------------+------------+-----------+--------+------------+
| emp_no | birth_date | first_name | last_name | gender | hire_date  |
+--------+------------+------------+-----------+--------+------------+
| 79962  | 1953-05-29 | Maik       | Heping    | M      | 1995-08-09 |
| 83076  | 1960-09-07 | Jacopo     | Thiria    | M      | 1999-07-20 |
| 88961  | 1954-03-07 | Uta        | Asser     | F      | 1998-12-02 |
| 203599 | 1965-01-21 | Ewing      | DiGiano   | M      | 1985-04-27 |
| 253428 | 1954-04-06 | Ortrun     | Benner    | F      | 1995-01-31 |
| 262244 | 1963-05-08 | Gal        | Ramaiah   | F      | 1989-08-01 |
| 414550 | 1960-02-01 | Sandeepan  | Krogh     | F      | 1992-01-04 |
+--------+------------+------------+-----------+--------+------------+
7 rows in set
```
- 正規表現を使ってリファクタリング
```
irb(main):006:0> Title.joins(:employee).select("employees.*").where(title: "Technique Leader").where(from_date: "2000-1-29"..)
  Title Load (158.7ms)  SELECT employees.* FROM `titles` INNER JOIN `employees` ON `employees`.`emp_no` = `titles`.`emp_no` WHERE `titles`.`title` = 'Technique Leader' AND `titles`.`from_date` >= '2000-01-29'
+--------+------------+------------+-----------+--------+------------+
| emp_no | birth_date | first_name | last_name | gender | hire_date  |
+--------+------------+------------+-----------+--------+------------+
| 79962  | 1953-05-29 | Maik       | Heping    | M      | 1995-08-09 |
| 83076  | 1960-09-07 | Jacopo     | Thiria    | M      | 1999-07-20 |
| 88961  | 1954-03-07 | Uta        | Asser     | F      | 1998-12-02 |
| 203599 | 1965-01-21 | Ewing      | DiGiano   | M      | 1985-04-27 |
| 253428 | 1954-04-06 | Ortrun     | Benner    | F      | 1995-01-31 |
| 262244 | 1963-05-08 | Gal        | Ramaiah   | F      | 1989-08-01 |
| 414550 | 1960-02-01 | Sandeepan  | Krogh     | F      | 1992-01-04 |
+--------+------------+------------+-----------+--------+------------+
7 rows in set
```

## 7.部署番号がd001である部署のマネージャー歴代一覧を取得してきてください
```
irb(main):009:0> DeptManager.joins(:employee).select("employees.emp_no","employees.birth_date","employees.first_name","employees.last_name","employees.gender","employees.hire_date").where(dept_no: "d001")
  DeptManager Load (25.8ms)  SELECT employees.emp_no, employees.birth_date, employees.first_name, employees.last_name, employees.gender, employees.hire_date FROM `dept_manager` INNER JOIN `employees` ON `employees`.`emp_no` = `dept_manager`.`emp_no` WHERE `dept_manager`.`dept_no` = 'd001'
+--------+------------+------------+------------+--------+------------+
| emp_no | birth_date | first_name | last_name  | gender | hire_date  |
+--------+------------+------------+------------+--------+------------+
| 110022 | 1956-09-12 | Margareta  | Markovitch | M      | 1985-01-01 |
| 110039 | 1963-06-21 | Vishwani   | Minakawa   | M      | 1986-04-12 |
+--------+------------+------------+------------+--------+------------+
2 rows in set
```
- 正規表現を使ってリファクタリング
```
irb(main):007:0> DeptManager.joins(:employee).select("employees.*").where(dept_no: "d001")
  DeptManager Load (2.6ms)  SELECT employees.* FROM `dept_manager` INNER JOIN `employees` ON `employees`.`emp_no` = `dept_manager`.`emp_no` WHERE `dept_manager`.`dept_no` = 'd001'
+--------+------------+------------+------------+--------+------------+
| emp_no | birth_date | first_name | last_name  | gender | hire_date  |
+--------+------------+------------+------------+--------+------------+
| 110022 | 1956-09-12 | Margareta  | Markovitch | M      | 1985-01-01 |
| 110039 | 1963-06-21 | Vishwani   | Minakawa   | M      | 1986-04-12 |
+--------+------------+------------+------------+--------+------------+
2 rows in set
```
## 8.歴代マネージャーにおける男女比を出してください
```
irb(main):019:0> DeptManager.joins(:employee).group("employees.gender").count
   (24.2ms)  SELECT COUNT(*) AS count_all, employees.gender AS employees_gender FROM `dept_manager` INNER JOIN `employees` ON `employees`.`emp_no` = `dept_manager`.`emp_no` GROUP BY employees.gender
=> {"M"=>11, "F"=>13}
```

## 9.部署番号がd004の部署における1999-1-1時点のマネージャーを取得してください
```
irb(main):006:0> DeptManager.joins(:employee).select("employees.emp_no","employees.birth_date","employees.first_name","employees.last_name","employees.gender","employees.hire_date").where(dept_no: "d004").where("from_date <= ?","1999-1-1").where("to_date >= ?","1999-1-1")
  DeptManager Load (1.3ms)  SELECT employees.emp_no, employees.birth_date, employees.first_name, employees.last_name, employees.gender, employees.hire_date FROM `dept_manager` INNER JOIN `employees` ON `employees`.`emp_no` = `dept_manager`.`emp_no` WHERE `dept_manager`.`dept_no` = 'd004' AND (from_date <= '1999-1-1') AND (to_date >= '1999-1-1')
+--------+------------+------------+-----------+--------+------------+
| emp_no | birth_date | first_name | last_name | gender | hire_date  |
+--------+------------+------------+-----------+--------+------------+
| 110420 | 1963-07-27 | Oscar      | Ghazalie  | M      | 1992-02-05 |
+--------+------------+------------+-----------+--------+------------+
1 row in set
```
- 正規表現を使ってリファクタリング
```
irb(main):009:0> DeptManager.joins(:employee).select("employees.*").where(dept_no: "d004").where("from_date <= ?","1999-1-1").where("to_date >= ?","1999-1-1")
  DeptManager Load (3.1ms)  SELECT employees.* FROM `dept_manager` INNER JOIN `employees` ON `employees`.`emp_no` = `dept_manager`.`emp_no` WHERE `dept_manager`.`dept_no` = 'd004' AND (from_date <= '1999-1-1') AND (to_date >= '1999-1-1')
+--------+------------+------------+-----------+--------+------------+
| emp_no | birth_date | first_name | last_name | gender | hire_date  |
+--------+------------+------------+-----------+--------+------------+
| 110420 | 1963-07-27 | Oscar      | Ghazalie  | M      | 1992-02-05 |
+--------+------------+------------+-----------+--------+------------+
1 row in set
```
## 10.従業員番号が10001, 10002, 10003の従業員が今までに稼いだ給料の合計を従業員ごとに集計してください
```
irb(main):001:0> Salary.joins(:employee).where(emp_no: ["10001","10002","10003"]).group(:emp_no).sum(:salary)
   (3.9ms)  SET NAMES utf8mb4,  @@SESSION.sql_mode = CONCAT(CONCAT(@@sql_mode, ',STRICT_ALL_TABLES'), ',NO_AUTO_VALUE_ON_ZERO'),  @@SESSION.sql_auto_is_null = 0, @@SESSION.wait_timeout = 2147483
   (0.8ms)  SELECT SUM(`salaries`.`salary`) AS sum_salary, `salaries`.`emp_no` AS salaries_emp_no FROM `salaries` INNER JOIN `employees` ON `employees`.`emp_no` = `salaries`.`emp_no` WHERE `salaries`.`emp_no` IN (10001, 10002, 10003) GROUP BY `salaries`.`emp_no`
=> {10001=>1281612, 10002=>413127, 10003=>301212}
```
## 11.上記に加えtotal_salaryという仮のフィールドを作ってemployeeの情報とがっちゃんこしてください。
```
irb(main):011:0> Salary.joins(:employee).select("employees.emp_no","employees.birth_date","employees.first_name","employees.last_name","employees.gender","employees.hire_date").where(emp_no: ["10001","10002","10003"]).group(:emp_no).select("SUM(salary) AS total_salary")
  Salary Load (28.2ms)  SELECT employees.emp_no, employees.birth_date, employees.first_name, employees.last_name, employees.gender, employees.hire_date, SUM(salary) AS total_salary FROM `salaries` INNER JOIN `employees` ON `employees`.`emp_no` = `salaries`.`emp_no` WHERE `salaries`.`emp_no` IN (10001, 10002, 10003) GROUP BY `salaries`.`emp_no`
+--------+------------+------------+-----------+--------+------------+--------------+
| emp_no | birth_date | first_name | last_name | gender | hire_date  | total_salary |
+--------+------------+------------+-----------+--------+------------+--------------+
| 10001  | 1953-09-02 | Georgi     | Facello   | M      | 1986-06-26 | 1281612      |
| 10002  | 1964-06-02 | Bezalel    | Simmel    | F      | 1985-11-21 | 413127       |
| 10003  | 1959-12-03 | Parto      | Bamford   | M      | 1986-08-28 | 301212       |
+--------+------------+------------+-----------+--------+------------+--------------+
3 rows in set
```
- 正規表現を使ってリファクタリング
```
irb(main):011:0> Salary.joins(:employee).select("employees.*").where(emp_no: ["10001","10002","10003"]).group(:emp_no).select("SUM(salary) AS total_salary")
  Salary Load (0.8ms)  SELECT employees.*, SUM(salary) AS total_salary FROM `salaries` INNER JOIN `employees` ON `employees`.`emp_no` = `salaries`.`emp_no` WHERE `salaries`.`emp_no` IN (10001, 10002, 10003) GROUP BY `salaries`.`emp_no`
+--------+------------+------------+-----------+--------+------------+--------------+
| emp_no | birth_date | first_name | last_name | gender | hire_date  | total_salary |
+--------+------------+------------+-----------+--------+------------+--------------+
| 10001  | 1953-09-02 | Georgi     | Facello   | M      | 1986-06-26 | 1281612      |
| 10002  | 1964-06-02 | Bezalel    | Simmel    | F      | 1985-11-21 | 413127       |
| 10003  | 1959-12-03 | Parto      | Bamford   | M      | 1986-08-28 | 301212       |
+--------+------------+------------+-----------+--------+------------+--------------+
3 rows in set
```

## 12.上記の結果を利用してコンソール上に以下のようなフォーマットでputsしてください。
```
# DBから取得して、salalyに格納
irb(main):001:0> salaly = Salary.joins(:employee).select("employees.emp_no").select("CONCAT(employees.first_name,' ',employees.last_name) AS full_name").where(emp_no: ["10001","10002","10003"]).group(:emp_no).select("SUM(salary) AS total_salary")
   (3.7ms)  SET NAMES utf8mb4,  @@SESSION.sql_mode = CONCAT(CONCAT(@@sql_mode, ',STRICT_ALL_TABLES'), ',NO_AUTO_VALUE_ON_ZERO'),  @@SESSION.sql_auto_is_null = 0, @@SESSION.wait_timeout = 2147483
  Salary Load (6.2ms)  SELECT employees.emp_no, CONCAT(employees.first_name,' ',employees.last_name) AS full_name, SUM(salary) AS total_salary FROM `salaries` INNER JOIN `employees` ON `employees`.`emp_no` = `salaries`.`emp_no` WHERE `salaries`.`emp_no` IN (10001, 10002, 10003) GROUP BY `salaries`.`emp_no`
+--------+----------------+--------------+
| emp_no | full_name      | total_salary |
+--------+----------------+--------------+
| 10001  | Georgi Facello | 1281612      |
| 10002  | Bezalel Simmel | 413127       |
| 10003  | Parto Bamford  | 301212       |
+--------+----------------+--------------+
3 rows in set

# コンソールに出力
# もう少しスマートな書き方がありそう
irb(main):002:0> salaly.each do |s|
irb(main):003:1* p "emp_no: #{s.emp_no}"
irb(main):004:1> p "full_name: #{s.full_name}"
irb(main):005:1> p "total_salary: #{s.total_salary}"
irb(main):006:1> end
"emp_no: 10001"
"full_name: Georgi Facello"
"total_salary: 1281612"
"emp_no: 10002"
"full_name: Bezalel Simmel"
"total_salary: 413127"
"emp_no: 10003"
"full_name: Parto Bamford"
"total_salary: 301212"
+--------+----------------+--------------+
| emp_no | full_name      | total_salary |
+--------+----------------+--------------+
| 10001  | Georgi Facello | 1281612      |
| 10002  | Bezalel Simmel | 413127       |
| 10003  | Parto Bamford  | 301212       |
+--------+----------------+--------------+
3 rows in set
```

### いろいろ試行錯誤
```
# そのままだと、ActiveRecordRelationクラスとなっている
salaly.class
 => Salary::ActiveRecord_Relation
```
```
s.class
Salary(emp_no: integer, salary: integer, from_date: date, to_date: date)
Salary(emp_no: integer, salary: integer, from_date: date, to_date: date)
Salary(emp_no: integer, salary: integer, from_date: date, to_date: date)
```

### 参考
- [【Ruby】 to_aメソッドの使い方を理解しよう](https://pikawaka.com/ruby/to_a)