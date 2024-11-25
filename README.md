# Proyek Akhir Semester B02

🔗 YumYogya versi mobile dapat Anda unduh melalui halaman releases atau pun melalui Microsoft App Center 

## Aplikasi: *YumYogya* :plate_with_cutlery:

### Anggota kelompok B02 👤
1. Abella Maya Santi - 2306275462
2. Fakhriyah Ghania Putri - 2306245466
3. Hizounya Maycinto Alkian - 2306245661
4. Lisa Margaretha Esron Tobing - 2306245541
5. Trias Fahri Naufal - 2306212096

## Deskripsi Aplikasi 🍲
*YumYogya* adalah sebuah platform yang menampilkan daftar makanan yang tersedia di Yogyakarta lengkap dengan informasi tentang tempat makannya. Pengguna dapat mencari berbagai makanan dan menemukan rekomendasi tempat makan yang menyajikan makanan tersebut. Berikut ini adalah manfaat dari aplikasi:
- Aplikasi ini berguna bagi wisatawan atau penduduk lokal yang ingin mengeksplor kuliner di Yogyakarta.
- Pengguna bisa dengan cepat menemukan tempat makan sesuai makanan yang mereka cari serta mendapatkan informasi tambahan mengenai rating dan review makanan.
- Dengan adanya rating dan ulasan, pengguna dapat memilih tempat makan terbaik berdasarkan pengalaman orang lain.
- Pengguna tidak perlu repot-repot mencari informasi dari berbagai sumber karena semua sudah terintegrasi di satu tempat.

## Pembagian Tugas Modul 📋

| Name | Module |
|------|--------|
| Abella Maya Santi | Bookmark |
| Fakhriyah Ghania Putri | Account & Dashboard |
| Hizounya Maycinto Alkian | Detail Makanan |
| Lisa Margaretha Esron Tobing | Forum |
| Trias Fahri Naufal | Homepage |

## Daftar Modul 📂
1. *Account & Dashboard*

   Modul *Account dan Dashboard* berfungsi sebagai pusat autentikasi sekaligus pusat kendali akun bagi pengguna yang sudah _login_. Pengguna yang terautentikasi dapat melakukan _login_, _logout_, penggantian _password_, dan pengelolaan informasi terkait profil mereka. Hanya pengguna yang terautentikasi (bukan _guest_) yang dapat mengubah _password_ dan _profil_ mereka melalui dashboard. Jika _guest_ mencoba mengakses _dashboard_, mereka akan langsung diarahkan ke *halaman _login_* atau *_register_*.

2. *Homepage*

   Modul *Homepage* berfungsi sebagai beranda utama aplikasi yang menampilkan berbagai informasi mengenai makanan serta berbagai fitur yang dapat diakses oleh *_user_* maupun _guest_. Ketika makanan diklik, _user/guest_ akan diarahkan ke *halaman detail makanan*.
   Fitur-fitur yang akan diterapkan dalam modul ini:
     - *Pencarian dan Rekomendasi Makanan*
       Pengguna dapat mencari berbagai jenis makanan yang tersedia di Yogyakarta melalui _search_ _bar_. Kemudian, makanan akan ditampilkan dengan urutan berdasarkan *rating tertinggi*.
     - *Filter dan Sorting*
       Pengguna bisa menggunakan *_filter_* untuk memilih makanan berdasarkan kategori tertentu, seperti harga, *jenis kuliner*, dan lainnya.
     
3. *Bookmark*

   Modul *Bookmark* memberikan fitur kepada *user* untuk menyimpan makanan atau tempat makan favorit mereka agar dapat diakses kembali dengan mudah di lain waktu. Fitur ini hanya tersedia untuk *user* yang sudah _login_, sedangkan *_guest_* tidak memiliki akses untuk menambahkan _bookmark_ dan akan diarahkan ke *halaman _login_* jika mencoba menggunakannya. Selain itu, pengguna juga dapat membuat label dan menyimpan makanan pada label tersebut 

4. *Forum*  

   Modul *Forum* memberikan akses kepada *_user_* untuk membuat dan berpartisipasi dalam diskusi terkait topik tertentu. Pengguna dapat memulai diskusi, memberikan tanggapan, serta berbagi informasi atau pengalaman mereka. Fitur-fitur yang diterapkan dalam modul ini:
     - *Membuat Forum Diskusi* 
       Pengguna yang terautentikasi dapat membuat forum baru terkait topik tertentu, seperti makanan, tempat makan, atau rekomendasi kuliner di Yogyakarta.
     - *Memberi Tanggapan*  
       Pengguna yang terautentikasi juga dapat memberikan tanggapan atau komentar pada forum yang sudah ada, memperluas diskusi dan berbagi pendapat mereka.
     - *Akses Terbatas untuk Guest*  
       *Guest* hanya bisa melihat diskusi yang ada, tetapi tidak dapat membuat forum atau memberikan tanggapan. Mereka akan diarahkan ke halaman login jika mencoba berpartisipasi dalam diskusi.
       
5. *Detail Makanan*

   Modul *Detail Makanan* berfungsi untuk menampilkan informasi lengkap tentang suatu makanan tertentu yang dipilih pengguna dari halaman *Homepage* atau *Bookmark*.
   Informasi yang ditampilkan meliputi:
      - Nama makanan
      - Rating
      - Deskripsi makanan
      - Harga
      - Nama tempat makan
      - Alamat tempat makan

   Pengguna juga dapat melihat *review* mengenai makanan tersebut. *Guest* dan *user* yang sudah login dapat mengakses dan melihat detail makanan pada halaman ini, tetapi *guest* tidak dapat menulis review atau menambah bookmark. *Review* memberikan akses bagi *pengguna* untuk memberikan ulasan atau penilaian terhadap makanan atau tempat makan yang telah mereka kunjungi. Pengguna dapat menilai berdasarkan bintang dan memberikan komentar disertai foto. Selain itu, pengguna juga dapat menghapus komentar milik mereka.

## Role Pengguna Aplikasi 🧑‍💻

| User | Guest |
|------|-----------|
| Memiliki akses lebih luas, seperti menyimpan daftar makanan (bookmark) dan berinteraksi dengan konten, misalnya memberikan ulasan. | Dapat menjelajahi aplikasi, tetapi hanya bisa melihat informasi tanpa melakukan tindakan lebih lanjut, seperti memberikan ulasan atau menyimpan bookmark. |

## Alur Pengintegrasian dengan Aplikasi Web 🌐
1. Menambahkan _dependency_ http untuk mengelola pertukaran data melalui permintaan HTTP.
2. Mengintegrasikan dukungan autentikasi berbasis cookie pada aplikasi dengan menggunakan _library_ pbp_django_auth.
3. Membuat model sesuai dengan struktur data yang diterima dari web aplikasi proyek tengah semester.
4. Mengirim permintaan HTTP ke web service dengan memanfaatkan _library_ http.
5. Mengimplementasikan REST API di Django melalui views.py dengan menggunakan Django Serializers atau JsonResponse.
6. Mengonversi data yang diterima dari web service ke dalam objek model yang telah dibuat sebelumnya.
7. Menampilkan data yang sudah dikonversi ke dalam aplikasi Flutter menggunakan _widget_ FutureBuilder.
8. Melakukan integrasi antara antarmuka pengguna (_front-end_) dan logika sistem (_back-end_) dengan memanfaatkan konsep _asynchronous_ HTTP.
