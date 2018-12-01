機能開発ハンズオン
====

# 開発環境の準備

## はじめに

本コマンドリストでは、テキストエディタとして vi を使用します。
適時お好みのエディタをご利用ください。

## Unicorn の停止

~~~~
cd $HOME/shirasagi
rake unicorn:stop
~~~~

## ソースコード取得

~~~~
cd $HOME
git clone https://github.com/shirasagi/ss-handson sample
cd sample
~~~~

## 設定ファイル

~~~~
cp -n config/samples/*.{rb,yml} config/
~~~~

## ハンズオン用DB

~~~~
vi config/mongoid.yml
~~~~

エディタで以下のコードを参考に記述してください。

~~~~
# mongodb configuration
production:
  sessions:
    default:
      database: ss_sample

development:
  sessions:
    default:
      database: ss_sample
~~~~

## Railsを開発モードへ変更

~~~
cp config/defaults/environment.yml config/
vi config/environment.yml
~~~

エディタで以下のコードを参考に記述してください。

~~~~
# default environment
RAILS_ENV: development
~~~~

## 外部依存モジュールのインストール

~~~
bundle install
~~~

## 初期データ投入

~~~~
rake db:drop
rake db:create_indexes
rake ss:create_site data='{ name: "サイト名", host: "www", domains: "localhost:3000" }'
rake db:seed name=demo site=www
~~~~

## Unicorn起動

~~~~
rake unicorn:start
~~~~

# ハンズオン1: 既存アドオンの拡張

## 連絡先アドオンの検索

~~~~
vi app/models/article/page.rb
~~~~

## フィールドをモデルへ追加

~~~~
vi app/models/concerns/contact/addon/page.rb
~~~~

エディタで以下のコードを参考に記述してください。

~~~~
module Contact::Addon
  module Page
    extend ActiveSupport::Concern
    extend SS::Addon

    included do
      field :contact_state, type: String
      field :contact_charge, type: String
      field :contact_tel, type: String
      field :contact_fax, type: String
      field :contact_email, type: String
      field :contact_night_window, type: String
      belongs_to :contact_group, class_name: "SS::Group"
      permit_params :contact_state, :contact_group_id, :contact_charge
      permit_params :contact_tel, :contact_fax, :contact_email
      permit_params :contact_night_window
    end

~~~~

## 夜間窓口の入力画面の開発

~~~
vi app/views/contact/agents/addons/page/_form.html.erb
~~~

エディタで以下のコードを参考に記述してください。

~~~

  <dt><%= @model.t :contact_email %><%= @model.tt :contact_email %></dt>
  <dd><%= f.text_field :contact_email, value: (params[:action] =~ /new/) ? @cur_group[:contact_email] : @item.contact_email %></dd>

  <dt><%= @model.t :contact_night_window %><%= @model.tt :contact_night_window %></dt>
  <dd><%= f.text_field :contact_night_window %></dd>
</dl>
~~~


## 夜間窓口の表示画面の開発

~~~
vi app/views/contact/agents/addons/page/_show.html.erb
~~~

エディタで以下のコードを参考に記述してください。

~~~

  <dt><%= @model.t :contact_email %></dt>
  <dd class="contact-email"><%= @item.contact_email %></dd>

  <dt><%= @model.t :contact_night_window %></dt>
  <dd class="contact-night-window"><%= @item.contact_night_window %></dd>
</dl>
~~~


## 日本語ロケールの作成

~~~
vi config/locales/contact/ja.yml
~~~

エディタで以下のコードを参考に記述してください。

~~~
mongoid:
    attributes:
      cms/model/page: &cmspage
        contact_state: 表示設定
        contact_group_id: 所属
        contact_group: 所属
        contact_charge: 担当
        contact_tel: 電話番号
        contact_fax: ファックス番号
        contact_email: メールアドレス
        contact_night_window: 夜間窓口
~~~

~~~
      contact_email:
        - 連絡先に表示する部署または担当者のメールアドレスを記入します。
      contact_night_window:
        - 連絡先に表示する夜間窓口を記入します。
~~~

## 公開側の表示画面の開発

~~~
vi app/views/contact/agents/addons/page/view/index.html.erb
~~~

エディタで以下のコードを参考に記述してください。

~~~
    <% if @cur_page.contact_night_window.present? %>
      <dl class="night-charge">
        <dt><%= "#{t("contact.view.contact_night_window")}:" %></dt>
        <dd><%= @cur_page.contact_night_window %></dd>
      </dl>
    <% end %>
  </footer>
<% end %>
~~~

~~~
vi config/locales/contact/ja.yml
~~~

エディタで以下のコードを参考に記述してください。

~~~
    view:
      title: お問い合わせ
      tel: 電話
      fax: Fax
      email: E-Mail
      contact_night_window: 夜間窓口
~~~

# ハンズオン2: 新しいアドオンの作成

## モデルの作成

~~~
vi app/models/concerns/cms/addon/weather.rb
~~~

エディタで以下のコードを参考に記述してください。

~~~
module Cms::Addon
  module Weather
    extend ActiveSupport::Concern
    extend SS::Addon

    included do
      field :weather, type: String
      permit_params :weather

      public
        def weather_options
          [ ["晴れ", "sunny"], ["曇り", "cloudy"],
            ["雨", "rain"], ["雪", "snow"],
          ]
        end
    end
  end
end
~~~

## アドオンを記事ページへ組み込み

~~~
vi  app/models/article/page.rb
~~~

エディタで以下のコードを参考に記述してください。

~~~
class Article::Page
  include Cms::Model::Page
  include Cms::Page::SequencedFilename
  include Cms::Addon::EditLock
  include Workflow::Addon::Branch
  include Workflow::Addon::Approver
  include Cms::Addon::Meta
  include Gravatar::Addon::Gravatar
  include Cms::Addon::Body
  include Cms::Addon::BodyPart
  include Cms::Addon::File
  include Category::Addon::Category
  include Cms::Addon::ParentCrumb
  include Event::Addon::Date
  include Map::Addon::Page
  include Cms::Addon::RelatedPage
  include Cms::Addon::Weather
  include Contact::Addon::Page
~~~

## 入力画面と表示画面の作成

~~~
vi  app/views/cms/agents/addons/weather/_form.html.erb
~~~

エディタで以下のコードを参考に記述してください。

~~~
<dl class="see mod-cms-weather">
  <dt><%= @model.t :weather %><%= @model.tt :weather %></dt>
  <dd><%= f.select :weather, @item.weather_options, include_blank: true %></dd>
</dl>
~~~

~~~
vi app/views/cms/agents/addons/weather/_show.html.erb
~~~

エディタで以下のコードを参考に記述してください。

~~~
<dl class="see mod-cms-weather">
  <dt><%= @model.t :weather %></dt>
  <dd><%= @item.label :weather %></dd>
</dl>
~~~

## 公開画面の作成

~~~
vi app/views/cms/agents/addons/weather/view/index.html.erb
~~~

エディタで以下のコードを参考に記述してください。

~~~
<% if @cur_page.weather.present? %>
  <span class="weather <%= @cur_page.weather %>">
    <%= @cur_page.label :weather %>
  </span>
<% end %>
~~~

## 日本語化

~~~
vi config/locales/cms/ja.yml
~~~

エディタで以下のコードを参考にアドオンの名称を登録してください。

~~~
modules:
    cms: 標準機能
    addons:
      cms/role: ロール
      cms/group_permission: 権限
      ……
      cms/archive_view_switcher: アーカイブ用表示設定
      cms/weather: 天気

~~~

エディタで以下のコードを参考にアドオンのフィールドを登録してください。

~~~
 cms/import_page: 取り込みページ
    attributes:
      cms/content:
        released: 公開日時
        ……
      cms/addon/archive_view_switcher:
        archive_view: 表示設定
      cms/addon/weather:
        weather: 天気

~~~

エディタで以下のコードを参考にアドオンのツールチップを登録してください。

~~~
 tooltip:
    cms/model/page:
      destination_filename:
        - ページやフォルダーを移動します。
        ……

    cms/addon/weather:
      weather:
        - 天気を選択します。
~~~
