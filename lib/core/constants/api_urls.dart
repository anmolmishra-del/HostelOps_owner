class ApiUrls {
  // 🔐 AUTH BASE
  static const authBase =
      "https://suppositionless-geralyn-jovially.ngrok-free.dev";


  static const ownerBase =
      "https://suppositionless-geralyn-jovially.ngrok-free.dev/owner";


  static const sendOtp = "$authBase/auth/send-otp";
  static const verifyOtp = "$authBase/auth/verify-otp";


  static const createPg = "$ownerBase/hostels";

 static String payments(int hostelId) =>
    "https://suppositionless-geralyn-jovially.ngrok-free.dev/owner/bills/hostel/12";
  static String rooms(int hostelId) =>
      "$ownerBase/hostels/$hostelId/rooms";
      static String drooms(int hostelId) =>
      "$ownerBase/rooms/$hostelId";
      static const roomTypes = "$ownerBase/room_types";


        static String otpverify(int id) =>
     "$ownerBase/bills/transactions/${id}/verify-otp";
}