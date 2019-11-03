bosque_spam <-randomForest(factor(spam) ~ ., data = spam_entrena, 
                           ntree = 200, mtry = 6, importance=TRUE, verbose = TRUE)

imp_escaladas <- bosque_spam$importance[,3] / bosque_spam$importanceSD[,3]

importancias_escaladas <- importance(bosque_spam, type=1, scale=TRUE)
plot(imp_escaladas, importancias_escaladas)

importancias <- importance(bosque_spam, type=1, scale=FALSE)
plot(importancias_escaladas, importancias)
