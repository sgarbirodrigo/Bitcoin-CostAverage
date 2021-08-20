import 'package:get/get.dart';

class Messages extends Translations {
  @override
  Map<String, Map<String, String>> get keys => {
        'en_US': {
          'title': 'Bitcoin - Cost Average',
          'chart_title_allocation': "@coin Allocation",
          'daily_average_expense': 'Daily Average',
          'daily_average_expense_tip':
              "The average amount of @coin you are allocating daily on the coins shown below",
          'weekly_expense': 'Weekly',
          'weekly_expense_tip':
              "The total amount you are allocating weekly on the coins shown below",
          'monthly_expense': 'Monthly',
          'monthly_expense_tip':
              "The total amount you are allocating on the coins shown below considering four weeks",
          "trading": "Trading",
          "daily": "daily",
          "weekly": "weekly",
          "monthly": "monthly",
          "for": "por",
          "active_orders": "Active Orders",
          "active_orders_subtitle": "Executed on the selected days",
          "1W": "1W",
          "2W": "2W",
          "1M": "1M",
          "6M": "6M",
          "1Y": "1Y",
          "day": "day",
          "pause": "Pause",
          "activate": "Activate",
          "edit": "Edit",
          "history": "History",
          "not_enough_data": "Not enouth data to show on the selected period",
          "order_widget_empty":
              "Here you will be able to view all the orders that are being executed daily.",
          "sorry": "Sorry :\'(",
          "no_connection": "No internet connection.",
          "history_empty": "Here you will be able to view your trades history.",
          'Sunday': 'Sunday',
          'Monday': 'Monday',
          'Tuesday': 'Tuesday',
          'Wednesday': 'Wednesday',
          'Thursday': 'Thursday',
          'Friday': 'Friday',
          'Saturday': 'Saturday',
          'January': 'January',
          'February': 'February',
          'March': 'March',
          'April': 'April',
          'May': 'May',
          'June': 'June',
          'July': 'July',
          'August': 'August',
          'September': 'September',
          'October': 'October',
          'November': 'November',
          'December': 'December',
          'Jan': 'Jan',
          'Feb': 'Feb',
          'Mar': 'Mar',
          'Apr': 'Apr',
          'May_short': 'May',
          'Jun': 'Jun',
          'Jul': 'Jul',
          'Aug': 'Aug',
          'Sept': 'Sept',
          'Oct': 'Oct',
          'Nov': 'Nov',
          'Dec': 'Dec',
          "history_header_date": "@month @day, @year",
          "history_date_short": "@month @day, @year",
          "time_format": "h:mm a",
          "Bought": "Bought",
          "Price": "Price",
          "Fee": "Fee",
          "delete_order": 'Delete order',
          "delete_order_confirmation": "Are you sure you want to delete this order?",
          "Confirm": "Confirm",
          "Cancel": 'Cancel',
          "select_pair": "Select a pair",
          "CREATE": "CREATE",
          "UPDATE": "UPDATE",
          "amount_invest": "Amount to invest",
          "enter_value": "Please enter some value",
          "must_be_bigger_than_minimum": 'Must be bigger than the minimum amount',
          "invalid_number": "Invalid number",
          "minimum_amount": "Minimum Amount",
          "weekly_expense_total": "Weekly expense",
          "Loading...": "Loading...",
          "loading_available_pairs": "Loading available pairs...",
          "cancel_reset_password": "Don't want to reset password? ",
          "need_account": "Need an account? ",
          "have_account": "Have an account? ",
          "sign_in": "Sign In",
          "sign_up": "Sign Up",
          "email_sent": "Email sent!",
          "forgot_pass": "Forgot Password?",
          "forgot_pass_text":
              "To recover your password, you need to enter your registered email adress. We will sent the recovery link to your email.",
          "email": "Email",
          "enter_email": "Please enter an email address",
          "invalid_email": "Invalid email",
          "Send": "Send",
          "Password": "Password",
          "enter_pass": "Please enter a password",
          "rewrite_pass": "Rewrite Password",
          "please_rewrite_pass": "Please rewrite your password",
          "pass_not_match": "Password does not match",
          "Average": "Average",
          "email_cant_be_empty": "Email cannot be empty.",
          "pass_cant_be_empty": "Password cannot be empty.",
          "check_email": "Check your email!",
          "sent_instructions": "We\'ve sent your instructions.",
          "no_users": 'No user found for that email.',
          "wrong_pass_user": 'Wrong password provided for that user.',
          "profit_loss": "Profit/Loss",
          "invested": "Invested",
          "market_value": "Market Value",
          "no_acquisitions_over_period": "You have no acquisitions on the selected period.",
          "chart_short_date_legend": "@month @day",
          "selected_exchange": "Selected exchange: ",
          "tip_create_exclusive_account":
              'To ensure another level of security on your funds, create an exclusive account for ',
          "api_key": "API Key",
          "secret_key": "Secret Key",
          "readQR": "Read QR Code",
          "get_API_keys": 'Get your API keys.',
          "save": "save",
          "saving": "saving",
          "saved": "saved",
          "api_invalid": "API keys invalid!",
          "week_trial":"1-WEEK FREE TRIAL",
          "restore_purchase":"Restore Purchase",
          "cancel_anytime":"You can cancel anytime.",
          "agree_with":"\nBy subscribing you agreed with our ",
          "privacy_policy":"Privacy Policy",
          "and":" and ",
          "terms_of_use":"Terms of Use",
          "month":"month",
          'Home':'Home',
          'Orders':'Orders',
          'History':'History',
          'Settings':"Settings",
          "monday_unit":"M",
          "tuesday_unit":"T",
          "thursday_unit":"T",
          "wednesday_unit":"W",
          "friday_unit":"F",
          "saturday_unit":"S",
          "sunday_unit":"S",
          "how_work":"How we work?",
          "how_work_text":"We connect to your Exchange account and automatically execute your predefined orders daily at 11PM",
          "exchange":"Exchange: ",
          "lets_connect":"Let\'s connect to Binance",
          "lets_Connect_text":"To connect with your Binance account we need you to generate API keys on Binance website.",
          "creating_api":"Creating API key",
          "creating_api_text":"After logging into your Binance account, click [API Management] in the user center drop-down box.",
          "saving_api":"Saving API key",
          "saving_api_text":"After clicking [Create API], you will see API key and Secret Key, save those keys.\n\nAttention:\nCHECK \"Enable Spot & Margin Trading\"\n UNCHECK \"Enable Withdrawals\"",
          "skip":"Skip",
          "welcome":"Welcome",
          "welcome_text":"Bitcoin Cost Average strategy consists in investing a fixed amount of money on regular time interval.",
          "practical_example":"Practical Example",
          "practical_example_text":"It\'s January 1st, 2018, and John and Alice decides to purchase \$5,000 worth of Bitcoin.",
          "one_time_buy": "One time buy",
          "one_time_buy_text": "John decides to purchase today. The Bitcoin price at the time was \$13,800 per coin, which means that John now owns 0.362 BTC.",
          "cost_averaging":"Cost Averaging",
          "cost_averaging_text":"Alice decides she wants to purchase \$500 every month, for 10 months. 10 months later, Alice owns 0.61 BTC. ",
          "in_the_end":"In the end...",
          "in_the_end_text":"Alice has almost TWICE as much as John, even though they invested the same amount!",
          "connect":"Connect",
          "x_days_left":"Free trial - @days_left days left",
          "DISCONNECTED":"DISCONNECTED",
          "CONNECTED":"CONNECTED",
        },
        'pt_BR': {
          'chart_title_allocation': "Alocação de @coin",
          'title': 'Bitcoin - Cost Average',
          'daily_average_expense': 'Média Diária',
          'daily_average_expense_tip':
              "A média diária de @coin que você esta alocando diariamente nas moedas abaixo",
          'weekly_expense': 'Semanal',
          'weekly_expense_tip': "O total que você está alocando semanalmente nas moedas abaixo",
          'monthly_expense': 'Mensal',
          'monthly_expense_tip':
              "O total que você está alocando nas moedas abaixo durante quatro semanas",
          "trading": "Trocando",
          "daily": "diariamente",
          "weekly": "semanalmente",
          "monthly": "mensalmente",
          "for": "por",
          "active_orders": "Ordens Ativas",
          "active_orders_subtitle": "Executadas nos dias selecionados",
          "1W": "1S",
          "2W": "2S",
          "1M": "1M",
          "6M": "6M",
          "1Y": "1A",
          "day": "dia",
          "pause": "Pausar",
          "activate": "Ativar",
          "edit": "Editar",
          "history": "Histórico",
          "not_enough_data": "Sem dados suficientes para exibir no período selecionado",
          "order_widget_empty":
              "Aqui você verá todas as suas ordens que serão executadas diariamente.",
          "sorry": "Desculpe :\'(",
          "no_connection": "Sem conexão com a internet.",
          "history_empty": "Aqui você verá seu histórico diário.",
          'Sunday': 'Domingo',
          'Monday': 'Segunda',
          'Tuesday': 'Terça',
          'Wednesday': 'Quarta',
          'Thursday': 'Quinta',
          'Friday': 'Sexta',
          'Saturday': 'Sábado',
          'January': 'Janeiro',
          'February': 'Fevereiro',
          'March': 'Março',
          'April': 'Abril',
          'May': 'Maio',
          'June': 'Junho',
          'July': 'Julho',
          'August': 'Agosto',
          'September': 'Setembro',
          'October': 'Outubro',
          'November': 'Novembro',
          'December': 'Dezembro',
          'Jan': 'Jan',
          'Feb': 'Fev',
          'Mar': 'Mar',
          'Apr': 'Abr',
          'May_short': 'Mai',
          'Jun': 'Jun',
          'Jul': 'Jul',
          'Aug': 'Ago',
          'Sept': 'Set',
          'Oct': 'Out',
          'Nov': 'Nov',
          'Dec': 'Dez',
          "history_header_date": "@day de @month de @year",
          "history_date_short": "@day/@month/@year",
          "time_format": "H:mm",
          "Bought": "Comprou",
          "Price": "Preço",
          "Fee": "Taxa",
          "delete_order": 'Deletar ordem',
          "delete_order_confirmation": "Tem certeza que deseja apagar?",
          "Confirm": "Confirmar",
          "Cancel": 'Cancelar',
          "select_pair": "Selecionar moeda",
          "CREATE": "CRIAR",
          "UPDATE": "ATUALIZAR",
          "amount_invest": "Total a investir",
          "enter_value": "Insira um valor",
          "must_be_bigger_than_minimum": 'Deve ser menor que o valor mínimo',
          "invalid_number": "Número inválido",
          "minimum_amount": "Valor mínimo",
          "weekly_expense_total": "Gasto semanal",
          "Loading...": "Carregando...",
          "loading_available_pairs": "Carregando moedas disponíveis...",
          "cancel_reset_password": "Não quer resetar a senha? ",
          "need_account": "Precisa de uma conta? ",
          "have_account": "Tem uma conta? ",
          "sign_in": "Logar",
          "sign_up": "Cadastrar",
          "email_sent": "Email enviado!",
          "forgot_pass": "Esqueceu a senha?",
          "forgot_pass_text":
              "Para recuperar sua senha, você precisará do seu email registrado. Lhe enviaremos um link por email.",
          "email": "Email",
          "enter_email": "Por favor, insira seu email",
          "invalid_email": "Email inválido",
          "Send": "Enviar",
          "Password": "Senha",
          "enter_pass": "Insira sua senha",
          "rewrite_pass": "Reescreva sua senha",
          "please_rewrite_pass": "Por favor, reescreva sua senha",
          "pass_not_match": "Senhas não coincidem",
          "Average": "Média",
          "email_cant_be_empty": "Email não pode estar em branco.",
          "pass_cant_be_empty": "Senha não pode estar em branco.",
          "check_email": "Verifique seu email!",
          "sent_instructions": "Nós lhe enviamos as instruções",
          "no_users": 'Não encontramos um usuário com este email.',
          "wrong_pass_user": 'Senha incorreta.',
          "profit_loss": "Lucro/Prejuízo",
          "invested": "Investimento",
          "market_value": "Valor de Mercado",
          "no_acquisitions_over_period": "Você não realizou compras no período selecionado.",
          "chart_short_date_legend": "@day @month",
          "selected_exchange": "Exchange selecionada: ",
          "tip_create_exclusive_account":
              'Para garantir uma camada extra de segurança, crie uma conta exclusiva para utilizar com ',
          "api_key": "Chave API",
          "secret_key": "Chave Secreta",
          "readQR": "Ler código QR",
          "get_API_keys": 'Pegue suas chaves',
          "save": "salvar",
          "saving": "salvando",
          "saved": "salvo",
          "api_invalid": "Chaves API inválidas!",
          "week_trial":"7 DIAS GRATIS",
          "restore_purchase":"Restaurar compra",
          "cancel_anytime":"Você pode cancelar a qualquer momento.",
          "agree_with":"\nAo assinar você concorda com nossa ",
          "privacy_policy":"Política de Privacidade",
          "and":" e ",
          "terms_of_use":"Termos de Uso",
          "month":"mês",
          'Home':'Início',
          'Orders':'Ordens',
          'History':'Histórico',
          'Settings':"Opções",
          "monday_unit":"S",
          "tuesday_unit":"T",
          "thursday_unit":"Q",
          "wednesday_unit":"Q",
          "friday_unit":"S",
          "saturday_unit":"S",
          "sunday_unit":"D",
          "how_work":"Como nós funcionamos?",
          "how_work_text":"Nos conectamos com sua Exchange para executar as suas ordens de compra diáriamente as 23:00",
          "exchange":"Exchange: ",
          "lets_connect":"Vamos conectar a Binance",
          "lets_Connect_text":"Para conectar com a Binance nós precisamos que você gere suas chaves API no site da Binance.",
          "creating_api":"Criando chave API",
          "creating_api_text":"Após logar na Binance, clique em [Gerenciamento API] no menu do usuário, no canto direito superior.",
          "saving_api":"Salvando Chaves",
          "saving_api_text":"Após clicar em [Create API], você verá sua API key e Secret Key, salve-as.\n\nAtenção:\nMARQUE \"Enable Spot & Margin Trading\"\n DESMARQUE \"Habilitar Saques\"",
          "skip":"Pular",
          "welcome":"Bem-Vindo",
          "welcome_text":"Bitcoin Cost Average é uma estratégia que consiste em investir um valor fixo constantemente.",
          "practical_example":"Exemplo Prático",
          "practical_example_text":"É 1 de janeiro de 2018, e João e Maria decidem comprar \$5,000 em Bitcoin.",
          "one_time_buy": "Comprando de uma vez só",
          "one_time_buy_text": "João decide comprar hoje. O preço do Bitcoin na época era \$13,800 por Bitcoin, isso significa que João possui 0.362 BTC.",
          "cost_averaging": "Usando Cost Average",
          "cost_averaging_text":"Maria decide que ela vai comprar \$500 todo mês, durante 10 meses. 10 meses depois, Maria possui 0.61 BTC. ",
          "in_the_end":"No final...",
          "in_the_end_text":"Maria tem quase o DOBRO que João, mesmo tendo investido a mesma quantidade!",
          "connect":"Conectar",
          "x_days_left":"Teste Gratis - @days_left dia restante",
          "DISCONNECTED":"DESCONECTADO",
          "CONNECTED":"CONECTADO",
        }
      };
}
