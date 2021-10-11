﻿
Процедура ОбработкаПроведения(Отказ, Режим)
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	ПриходнаяНакладнаяСписокНоменклатуры.Номенклатура КАК Номенклатура,
		|	СУММА(ПриходнаяНакладнаяСписокНоменклатуры.Количество) КАК Количество,
		|	&Склад КАК Склад,
		|	&Период КАК Период,
		|	&ВидДвижения КАК ВидДвижения
		|ИЗ
		|	Документ.ПриходнаяНакладная.СписокНоменклатуры КАК ПриходнаяНакладнаяСписокНоменклатуры
		|ГДЕ
		|	ПриходнаяНакладнаяСписокНоменклатуры.Ссылка = &Ссылка
		|
		|СГРУППИРОВАТЬ ПО
		|	ПриходнаяНакладнаяСписокНоменклатуры.Номенклатура";
	
	Запрос.УстановитьПараметр("ВидДвижения", ВидДвиженияНакопления.Приход);
	Запрос.УстановитьПараметр("Период", Дата);
	Запрос.УстановитьПараметр("Склад", Склад);
	Запрос.УстановитьПараметр("Ссылка", Ссылка);
	
	РезультатЗапроса = Запрос.Выполнить();
	
	Движения.ОстаткиНоменклатуры.Записывать = Истина;
	ДВижения.ОстаткиНоменклатуры.Загрузить(РезультатЗапроса.Выгрузить());

	Движения.Управленческий.Записывать = Истина;
	Для Каждого ТекСтрокаСписокНоменклатуры Из СписокНоменклатуры Цикл
		Движение = Движения.Управленческий.Добавить();
		Движение.СчетДт = ПланыСчетов.Управленческий.Товары;
		Движение.СчетКт = ПланыСчетов.Управленческий.Поставщики;
		Движение.Период = Дата;
		Движение.Сумма = ТекСтрокаСписокНоменклатуры.Сумма;
		Движение.КоличествоДт = ТекСтрокаСписокНоменклатуры.Количество;
		Движение.СубконтоДт[ПланыВидовХарактеристик.ВидыСубконто.Номенклатура] = ТекСтрокаСписокНоменклатуры.Номенклатура;
		Движение.СубконтоДт[ПланыВидовХарактеристик.ВидыСубконто.Склады] = ТекСтрокаСписокНоменклатуры.Склад;
		Движение.СубконтоДт[ПланыВидовХарактеристик.ВидыСубконто.Партии] = Ссылка;
	КонецЦикла;
	
	//{{__КОНСТРУКТОР_ДВИЖЕНИЙ_РЕГИСТРОВ
	// Данный фрагмент построен конструктором.
	// При повторном использовании конструктора, внесенные вручную изменения будут утеряны!!!
	
	//}}__КОНСТРУКТОР_ДВИЖЕНИЙ_РЕГИСТРОВ
	
КонецПроцедуры
