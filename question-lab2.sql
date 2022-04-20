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


-- Найти однофамильцев в разных группах среди студентов и вывести пары ФИО – группа.

SELECT st.Фамилия, st.Имя, st.Отчество, gr.Наименование
FROM dbo.Студенты as st
INNER JOIN dbo.[Студенты в группах] as stgr ON stgr.[ID студента] = st.[ID студента]
INNER JOIN dbo.Группы as gr ON gr.[ID группы] = stgr.[ID группы]
CROSS JOIN dbo.Студенты as st1 
WHERE st1.Фамилия = st.Фамилия AND st.[ID студента] != st1.[ID студента]


-- Вывести в виде «рейтинга» ТОП-10 студентов с указанием сред-ней отметки по результатам обучения.

SELECT st.Фамилия, st.Имя, st.Отчество, AVG(zv.Отметка) as 'Средняя отметка' 
FROM dbo.Студенты as st
INNER JOIN dbo.[Зачетная ведомость] as zv ON st.[ID студента] = zv.[ID студента]
GROUP BY st.Фамилия, st.Имя, st.Отчество
ORDER BY AVG(zv.Отметка) DESC
--OFFSET 10 ROWS


-- Вывести ФИО студентов, слушавших курс лекций, но не имеющих отметок в зачетной ведомости.

SELECT st.Фамилия, st.Имя, st.Отчество, zv.Отметка
FROM dbo.Студенты as st
INNER JOIN dbo.[Студенты в группах] as stgr ON stgr.[ID студента] = st.[ID студента]
FULL JOIN dbo.[Зачетная ведомость] as zv ON zv.[ID студента] = stgr.[ID студента]
GROUP BY st.Фамилия, st.Имя, st.Отчество, zv.Отметка
HAVING count(zv.Отметка) = 0


-- Вывести список групп и ФИО преподавателей, которые учатся и работают в одном институте.

SELECT gr.Наименование, pr.Имя, pr.Фамилия, pr.Отчество
FROM dbo.Группы as gr
INNER JOIN dbo.Институты as inst ON inst.[ID института] = gr.[ID института]
INNER JOIN dbo.Преподаватели as pr ON pr.[ID института] = inst.[ID института]
WHERE pr.[ID института] = gr.[ID института]
GROUP BY gr.Наименование, pr.Имя, pr.Фамилия, pr.Отчество

-- Вывести список дисциплин, по которым контроль проводится бо-лее чем в одной форме.

SELECT dis.Наименование
FROM dbo.Дисциплины as dis
INNER JOIN dbo.[Дисциплина в семестре] as disin ON disin.[Код дисциплины] = dis.[Код дисциплины]
INNER JOIN dbo.[Формы контроля] as form ON form.[Код формы контроля] = disin.[Код формы контроля]
GROUP BY dis.Наименование
HAVING count(DISTINCT disin.[Код формы контроля]) > 1


-- Вывести для каждого преподавателя количество «платников» (че-ловек), которые у него слушали лекции.

SELECT pr.Имя, pr.Фамилия, pr.Отчество, count( DISTINCT stgr.[ID студента]) as 'Количество платников'
FROM dbo.Преподаватели as pr
INNER JOIN dbo.[Дисциплина в семестре] as disin ON disin.[ID лектора] = pr.[ID преподавателя]
INNER JOIN dbo.[Студенты в группах] as stgr ON stgr.[ID группы] =  disin.[ID группы]
WHERE stgr.[Код формы оплаты] = 2
GROUP BY pr.Имя, pr.Фамилия, pr.Отчество


-- Вывести для каждого преподавателя количество «платников» (че-ловекосеместров), которые у него слушали лекции.

SELECT pr.Имя, pr.Фамилия, pr.Отчество, disin.[Номер семестра обучения], count( DISTINCT stgr.[ID студента]) as 'Количество платников'
FROM dbo.Преподаватели as pr
INNER JOIN dbo.[Дисциплина в семестре] as disin ON disin.[ID лектора] = pr.[ID преподавателя]
INNER JOIN dbo.[Студенты в группах] as stgr ON stgr.[ID группы] =  disin.[ID группы]
WHERE stgr.[Код формы оплаты] = 2
GROUP BY pr.Имя, pr.Фамилия, pr.Отчество, disin.[Номер семестра обучения]












