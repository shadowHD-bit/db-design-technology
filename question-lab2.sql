-- Вывести список групп с указанием количества человек в каждой. 

SELECT gr.Наименование, count(stgr.[ID студента]) as 'Количество студентов'
FROM dbo.Группы as gr 
INNER JOIN dbo.[Студенты в группах] as stgr ON gr.[ID группы] = stgr.[ID группы]
GROUP BY gr.Наименование


-- Вывести список групп с указанием количества юношей в них.

SELECT gr.Наименование, count(stgr.[ID студента]) as 'Количество юношей'
FROM dbo.Группы as gr 
INNER JOIN dbo.[Студенты в группах] as stgr ON gr.[ID группы] = stgr.[ID группы]
INNER JOIN dbo.Студенты as st ON stgr.[ID студента] = st.[ID студента]
WHERE st.Пол = 'true'
GROUP BY gr.Наименование


-- Вывести список групп с указанием количества юношей и девушек в них.

SELECT gr.Наименование, 
sum(CASE WHEN st.Пол = 'true' THEN 1 ELSE 0 END) as 'Юноши',
sum(CASE WHEN st.Пол = 'false' THEN 1 ELSE 0 END) as 'Девушки'
FROM dbo.Группы as gr 
INNER JOIN dbo.[Студенты в группах] as stgr ON gr.[ID группы] = stgr.[ID группы]
INNER JOIN dbo.Студенты as st ON stgr.[ID студента] = st.[ID студента]
GROUP BY gr.Наименование


-- Вывести список групп, в которых отсутствуют студенты.

SELECT gr.Наименование
FROM dbo.Группы as gr 
FULL JOIN dbo.[Студенты в группах] as stgr ON gr.[ID группы] = stgr.[ID группы]
GROUP BY gr.Наименование
HAVING count(stgr.[ID студента]) = 0


-- Вывести список групп, в которых один преподаватель в одном семестре читал лекции более чем по одной дисциплине.



-- Вывести список групп, в которых один преподаватель читал лекции более чем по одной «дисциплине в семестре».



-- Вывести ФИО студентов, обучающихся (обучавшихся) более чем в двух группах одновременно (с указанием количества групп).

SELECT st.Фамилия, st.Имя, st.Отчество, count(stgr.[ID группы]) as 'Количество групп'
FROM dbo.Студенты as st
INNER JOIN dbo.[Студенты в группах] as stgr ON stgr.[ID студента] = st.[ID студента]
GROUP BY st.Фамилия, st.Имя, st.Отчество
HAVING count(stgr.[ID группы])>2


-- Вывести ФИО студентов, обучающихся более чем в двух группах (с указанием количества групп).

SELECT st.Фамилия, st.Имя, st.Отчество, count(stgr.[ID группы]) as 'Количество групп'
FROM dbo.Студенты as st
INNER JOIN dbo.[Студенты в группах] as stgr ON stgr.[ID студента] = st.[ID студента]
INNER JOIN dbo.Группы as gr ON gr.[ID группы] = stgr.[ID группы] 
WHERE YEAR(GETDATE()) - (gr.[Год поступления] + gr.[Длительность обучения]) <= 0
GROUP BY st.Фамилия, st.Имя, st.Отчество
HAVING count(stgr.[ID группы])>2


-- Вывести ФИО студентов, обучающихся более чем в двух группах одновременно (с указанием количества групп).

SELECT st.Фамилия, st.Имя, st.Отчество, count(stgr.[ID группы]) as 'Количество групп'
FROM dbo.Студенты as st
INNER JOIN dbo.[Студенты в группах] as stgr ON stgr.[ID студента] = st.[ID студента]
INNER JOIN dbo.Группы as gr ON gr.[ID группы] = stgr.[ID группы] 
WHERE YEAR(GETDATE()) BETWEEN gr.[Год поступления] AND gr.[Год поступления]+gr.[Длительность обучения]
GROUP BY st.Фамилия, st.Имя, st.Отчество
HAVING count(stgr.[ID группы]) > 2


-- Вывести ФИО студентов, которые хотя бы один раз получили неудовлетворительную отметку.

SELECT st.Фамилия, st.Имя, st.Отчество
FROM dbo.Студенты as st
INNER JOIN dbo.[Зачетная ведомость] as zv ON zv.[ID студента] = st.[ID студента]
WHERE zv.Отметка < 3
GROUP BY st.Фамилия, st.Имя, st.Отчество


-- Вывести ФИО студентов, имеющих не более одной тройки.

SELECT st.Фамилия, st.Имя, st.Отчество
FROM dbo.Студенты as st
INNER JOIN dbo.[Зачетная ведомость] as zv ON zv.[ID студента] = st.[ID студента]
WHERE zv.Отметка = 3
GROUP BY st.Фамилия, st.Имя, st.Отчество
HAVING count(zv.[ID дисциплины в семестре]) <=1


-- Вывести ФИО студентов, имеющих только отметки «отлично».

SELECT st.Фамилия, st.Имя, st.Отчество
FROM dbo.Студенты as st
INNER JOIN dbo.[Зачетная ведомость] as zv ON zv.[ID студента] = st.[ID студента]
GROUP BY st.Фамилия, st.Имя, st.Отчество
HAVING sum(CASE WHEN zv.Отметка = 5 THEN 1 ELSE 0 END) = count(zv.Отметка)


-- Вывести ФИО студентов с указанием среднего балла по результа-там обучения в каждой группе.

SELECT st.Фамилия, st.Имя, st.Отчество, gr.Наименование, AVG(zv.Балл) as 'Ср. Балл'
FROM dbo.Студенты as st
INNER JOIN dbo.[Студенты в группах] as stgr ON stgr.[ID студента] = st.[ID студента]
INNER JOIN dbo.Группы as gr ON gr.[ID группы] = stgr.[ID группы]
INNER JOIN dbo.[Зачетная ведомость] as zv ON zv.[ID студента] = st.[ID студента]
GROUP BY st.Фамилия, st.Имя, st.Отчество, gr.Наименование

















