train = read.table("X_train.txt")
test = read.table("X_test.txt")
train = as.tibble(train)
test = as_tibble(test)
train_y = read.table("y_train.txt")
test_y = read.table("y_test.txt")
train_y = as_tibble(train_y)
test_y = as_tibble(test_y)
bax_test = read.table("body_acc_x_test.txt")
bax_train = read.table("body_acc_x_train.txt")
bay_test = read.table("body_acc_y_test.txt")
bay_train = read.table("body_acc_y_train.txt")
baz_test = read.table("body_acc_z_test.txt")
baz_train = read.table("body_acc_z_train.txt")
bgx_test = read.table("body_gyro_x_test.txt")
bgx_train = read.table("body_gyro_x_train.txt")
bgy_test = read.table("body_gyro_y_test.txt")
bgy_train = read.table("body_gyro_y_train.txt")
tax_test = read.table("total_acc_x_test.txt")
tax_train = read.table("total_acc_x_train.txt")
tay_train = read.table("total_acc_y_train.txt")
tay_test = read.table("total_acc_y_test.txt")
taz_test = read.table("total_acc_z_test.txt")
taz_train = read.table("total_acc_z_train.txt")
bax_test = as.tibble(bax_test)
bax_test = as_tibble(bax_test)
bax_train = as_tibble(bax_train)
bay_test = as_tibble(bax_test)
bay_train=as_tibble(bay_train)
baz_test = as_tibble(baz_test)
baz_train = as_tibble(baz_train)
bgx_test = as_tibble(bgx_test)
bgx_train = as_tibble(bgx_train)
bgy_test = as_tibble(bgx_test)
bgy_test = as_tibble(bgy_test)
bgy_train = as_tibble(bgy_train)
bgz_train = as_tibble(bgz_train)
bgz_test = as_tibble(bgz_test)
tax_test = as_tibble(tax_test)
tax_train = as_tibble(tax_train)
tay_train = as_tibble(tay_train)
tay_test = as_tibble(tay_test)
taz_test = as_tibble(taz_test)
taz_train = as_tibble(taz_train)
subject_test = read.table("subject_test.txt")
subject_train = read.table("subject_train.txt")
subject_test = as_tibble(subject_test)
subject_train = as_tibble(subject_train)

subject_train = subject_train %>% rename(ID = V1)
train_bind = bind_cols(subject_train, train)

subject_test = subject_test %>% rename(ID = V1)
test_bind = bind_cols(subject_test, test)

y_all = bind_rows(train_y, test_y)

all_bind = bind_rows(train_bind, test_bind)
all = bind_cols(all_bind,y_all)

bax_bind = bind_rows(bax_train, bax_test)
bay_bind = bind_rows(bay_train, bay_test)
baz_bind = bind_rows(baz_train, baz_test)

bgx_bind = bind_rows(bgx_train, bgx_test)
bgy_bind = bind_rows(bgy_train, bgy_test)
bgz_bind = bind_rows(bgz_train, bgz_test)

tax_bind = bind_rows(tax_train, tax_test)
tay_bind = bind_rows(tay_train, tay_test)
taz_bind = bind_rows(taz_train, taz_test)

features = read.table("features.txt")
features = as_tibble(features)
features$V2 = as.character(features$V2)

replacement = c(features$V2)

renaming = function(all, features){
  cols_to_replace = c(names(all))
  replacement_cols = c(names(features))
      for(i in length(cols_to_replace)) {
        all = all %>% mutate(replacement_cols[i] = cols_to_replace[i])
      }
  all_new = all
}

features$V2[c(303:316,382:395,461:474)] = str_replace(features$V2[c(303:316,382:395,461:474)], "f","Xf")
features$V2[c(317:330,396:409,475:488)] = str_replace(features$V2[c(317:330,396:409,475:488)], "f","Yf")
features$V2[c(331:344,410:423,489:502)] = str_replace(features$V2[c(331:344,410:423,489:502)], "f","Zf")
features = features %>% pivot_wider(names_from = V2, values_from = V1)


