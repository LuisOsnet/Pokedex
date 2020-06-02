class PokemonBotService
  # Target url
  URL = 'https://www.pokemon.com/el/pokedex/'.freeze

  # Initialize drivers
  def initialize
    Capybara.register_driver :chrome do |app|
      Capybara::Selenium::Driver.new(app, browser: :chrome)
    end
    Capybara.register_driver :headless_chrome do |app|
      capabilities = Selenium::WebDriver::Remote::Capabilities.chrome(
        chromeOptions: { args: %w[headless disable-gpu] }
      )
      Capybara::Selenium::Driver.new app,
                                     browser: :chrome,
                                     desired_capabilities: capabilities
    end
    Capybara.default_driver = :chrome
  end

  # Retrieve pokemons
  def run
    driver_env = Rails.env.production? ? :headless_chrome : :chrome
    session = Capybara::Session.new(driver_env)
    session.visit(URL)
    sleep 1
    # Retrieve pokemon list
    pokemons_list = session.find('ul.results').all('li')
    # Iterate to retrieve each pokemon data
    pokemons_list.each do |pokemon|
      pokemon_picture = pokemon.all('img').first['src']
      pokemon_name = pokemon.all('h5').first.text
      pokemon_category = pokemon.all('div.abilities').first.text
      pokemon_ability = pokemon.all('div.abilities').last.text
      # Save pokemon
      Pokemon.create!(
        picture: pokemon_picture,
        name: pokemon_name,
        category: pokemon_category,
        ability: pokemon_ability
      )
    end
  end
end