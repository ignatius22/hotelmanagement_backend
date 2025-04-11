# Clear existing data
Booking.destroy_all
Cabin.destroy_all
Setting.destroy_all
User.destroy_all

# Create Users
puts "Seeding Users..."
users = [
  { full_name: 'Jonas Schmedtmann', email: 'hello@jonas.io', nationality: 'Portugal', national_id: '3525436345', country_flag: 'https://flagcdn.com/pt.svg', password: "password", is_authenticated: true, role: "admin" },
  { full_name: 'Jonathan Smith', email: 'johnsmith@test.eu', nationality: 'Great Britain', national_id: '4534593454', country_flag: 'https://flagcdn.com/gb.svg', password: "password", is_authenticated: true, role: "guest" },
  { full_name: 'Jonatan Johansson', email: 'jonatan@example.com', nationality: 'Finland', national_id: '9374074454', country_flag: 'https://flagcdn.com/fi.svg', password: "password", is_authenticated: true, role: "guest" },
  { full_name: 'Jonas Mueller', email: 'jonas@example.eu', nationality: 'Germany', national_id: '1233212288', country_flag: 'https://flagcdn.com/de.svg', password: "password", is_authenticated: true, role: "guest" },
  { full_name: 'Jonas Anderson', email: 'anderson@example.com', nationality: 'Bolivia (Plurinational State of)', national_id: '0988520146', country_flag: 'https://flagcdn.com/bo.svg', password: "password", is_authenticated: true, role: "guest" },
  { full_name: 'Jonathan Williams', email: 'jowi@gmail.com', nationality: 'United States of America', national_id: '633678543', country_flag: 'https://flagcdn.com/us.svg', password: "password", is_authenticated: true, role: "guest" },
  { full_name: 'Emma Watson', email: 'emma.watson@gmail.com', nationality: 'United Kingdom', national_id: '1234578901', country_flag: 'https://flagcdn.com/gb.svg', password: "password", is_authenticated: true, role: "guest" },
  { full_name: 'Mohammed Ali', email: 'mohammedali@yahoo.com', nationality: 'Egypt', national_id: '987543210', country_flag: 'https://flagcdn.com/eg.svg', password: "password", is_authenticated: true, role: "guest" },
  { full_name: 'Maria Rodriguez', email: 'maria@gmail.com', nationality: 'Spain', national_id: '1098765321', country_flag: 'https://flagcdn.com/es.svg', password: "password", is_authenticated: true, role: "guest" },
  { full_name: 'Li Mei', email: 'li.mei@hotmail.com', nationality: 'China', national_id: '102934756', country_flag: 'https://flagcdn.com/cn.svg', password: "password", is_authenticated: true, role: "guest" }
]
users.each { |user| User.create!(user) }

# Create Cabins
puts "Seeding Cabins..."
cabins = [
  { name: "001", max_capacity: 2, regular_price: 250, discount: 0, image: "https://via.placeholder.com/150?text=Cabin+001", description: "Cozy cabin for couples." },
  { name: "002", max_capacity: 2, regular_price: 350, discount: 25, image: "https://via.placeholder.com/150?text=Cabin+002", description: "Luxury couple retreat." },
  { name: "003", max_capacity: 4, regular_price: 300, discount: 0, image: "https://via.placeholder.com/150?text=Cabin+003", description: "Family cabin for 4." },
  { name: "004", max_capacity: 4, regular_price: 500, discount: 50, image: "https://via.placeholder.com/150?text=Cabin+004", description: "Premium family cabin." },
  { name: "005", max_capacity: 6, regular_price: 350, discount: 0, image: "https://via.placeholder.com/150?text=Cabin+005", description: "Spacious group cabin." },
  { name: "006", max_capacity: 6, regular_price: 800, discount: 100, image: "https://via.placeholder.com/150?text=Cabin+006", description: "Luxury group retreat." },
  { name: "007", max_capacity: 8, regular_price: 600, discount: 100, image: "https://via.placeholder.com/150?text=Cabin+007", description: "Large family cabin." },
  { name: "008", max_capacity: 10, regular_price: 1400, discount: 0, image: "https://via.placeholder.com/150?text=Cabin+008", description: "Grand luxury cabin." }
]
cabins.each { |cabin| Cabin.create!(cabin) }

# Create Settings
puts "Seeding Settings..."
Setting.create!(
  min_booking_length: 1,
  max_booking_length: 14,
  max_guests_per_booking: 6,
  breakfast_price: 15.0
)

# Create Bookings
puts "Seeding Bookings..."
bookings = [
  {
    start_date: Date.today + 1,
    end_date: Date.today + 3,
    num_nights: 2,
    num_guests: 2,
    total_price: 230.0, # Matches Cabin 001 final_price (250 - 0) + breakfast (15 * 2)
    status: "unconfirmed",
    has_breakfast: true,
    extras_price: 30.0, # 2 guests * 15 breakfast_price
    observations: "Please prepare the cabin with extra towels.",
    is_paid: true,
    cabin_id: Cabin.find_by(name: "001").id,
    user_id: User.find_by(email: "jowi@gmail.com").id
  },
  {
    start_date: Date.today + 5,
    end_date: Date.today + 7,
    num_nights: 2,
    num_guests: 4,
    total_price: 350.0, # Matches Cabin 008 final_price (1400 - 0) / 4 (simplified for seed)
    status: "unconfirmed",
    has_breakfast: false,
    extras_price: 0.0,
    observations: "Late check-in requested.",
    is_paid: false,
    cabin_id: Cabin.find_by(name: "008").id,
    user_id: User.find_by(email: "emma.watson@gmail.com").id
  }
]
bookings.each { |booking| Booking.create!(booking) }

puts "Seeding completed successfully!"