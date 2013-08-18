# coding: utf-8 

namespace :db do
  desc "Fill database with sample data"
  task populate: :environment do
    make_pages
  end
end

def make_pages
  products_page = Page.create!(
    name:    'products',
    title:   'Товары',
    content: 'Большой ассортимент товаров!'
  )

  tvs_page = Page.create!(
    name:    'TVs',
    title:   'Телевизоры',
    content: 'Множество моделей с различной диагональю экрана.',
    parent:   products_page
  )

  monitors_page = Page.create!(
    name:    'monitors',
    title:   'Мониторы',
    content: 'Мониторы самых разных марок по самым низким ценам в городе!',
    parent:   products_page
  )

  lcd_tvs_page = Page.create!(
    name:    'LCD',
    title:   'LCD-телевизоры',
    content: "Жидкокристаллический дисплей (ЖК-дисплей, ЖКД;
              жидкокристаллический индикатор, ЖКИ; англ. Liquid crystal display, LCD)
              — плоский дисплей на основе жидких кристаллов, а также устройство
              (монитор, телевизор) на основе такого дисплея.",
    parent:   tvs_page
  )

  lcd_monitors_page = Page.create!(
    name:    'LCD',
    title:   'LCD-мониторы',
    content: "Жидкокристаллический дисплей (ЖК-дисплей, ЖКД;
              жидкокристаллический индикатор, ЖКИ; англ. Liquid crystal display, LCD)
              — плоский дисплей на основе жидких кристаллов, а также устройство
              (монитор, телевизор) на основе такого дисплея.",
    parent:   monitors_page
  )

  led_tvs_page = Page.create!(
    name:    'LED',
    title:   'LED-телевизоры',
    content: 'В LED телевизорах в качестве подсветки используются диоды
              – полупроводниковый прибор, создающий излучение (свечение) при
              прохождении через него электрического тока.',
    parent:   tvs_page
  )

  services_page = Page.create!(
    name:    'services',
    title:   'Услуги',
    content: 'Услуги по установке и ремонту оборудования.'
  )

  installation_serv_page = Page.create!(
    name:    'installation',
    title:   'Установка оборудования',
    content: 'Установка телевизионного и компьютерного оборудования руками
              профессионалов.',
    parent:   services_page
  )

  repair_serv_page = Page.create!(
    name:    'repair',
    title:   'Ремонт оборудования',
    content: 'Ремонт телевизионного и компьютерного оборудования любой сложности.',
    parent:   services_page
  )

  formating_example_page = Page.create!(
    name:    'formating_example',
    title:   'Пример использования шаблонов',
    content: "\\\\You can visit the **following link**\\\\ to know more
              about **((/products/TVs/LED LED))**"
  )
     
end
