import React from 'react';
import Image from 'next/image';
import Layout from '@/components/layout/Layout';

export default function AboutPage() {
  return (
    <Layout title="Về chúng tôi | Eyewear Store" 
            description="Eyewear Store - Cửa hàng kính mắt cao cấp hàng đầu Việt Nam với hơn 15 năm kinh nghiệm và các thương hiệu nổi tiếng thế giới.">
      <div className="bg-white">
        {/* Hero section */}
        <div className="relative bg-indigo-800">
          <div className="absolute inset-0">
            <Image
              src="/images/about/store-front.jpg"
              alt="Cửa hàng Eyewear Store"
              fill
              className="w-full h-full object-cover mix-blend-multiply"
            />
            <div className="absolute inset-0 bg-indigo-800 mix-blend-multiply" aria-hidden="true" />
          </div>
          <div className="relative max-w-7xl mx-auto py-24 px-4 sm:py-32 sm:px-6 lg:px-8">
            <h1 className="text-4xl font-extrabold tracking-tight text-white sm:text-5xl lg:text-6xl">Về Eyewear Store</h1>
            <p className="mt-6 max-w-3xl text-xl text-indigo-100">
              15 năm kinh nghiệm mang đến những sản phẩm kính mắt chất lượng cao và dịch vụ tận tâm
            </p>
          </div>
        </div>

        {/* Our Story section */}
        <div className="max-w-7xl mx-auto py-16 px-4 sm:px-6 lg:py-24 lg:px-8">
          <div className="lg:grid lg:grid-cols-2 lg:gap-8 items-center">
            <div>
              <h2 className="text-3xl font-extrabold text-gray-900 sm:text-4xl">
                Câu chuyện của chúng tôi
              </h2>
              <p className="mt-4 text-lg text-gray-500">
                Eyewear Store được thành lập vào năm 2008 với sứ mệnh mang đến những sản phẩm kính mắt chất lượng cao từ các thương hiệu hàng đầu thế giới cho người tiêu dùng Việt Nam.
              </p>
              <p className="mt-4 text-lg text-gray-500">
                Từ một cửa hàng nhỏ, chúng tôi đã phát triển thành chuỗi cửa hàng với hơn 20 chi nhánh trên toàn quốc, phục vụ hàng ngàn khách hàng mỗi ngày với đa dạng sản phẩm từ kính mắt thời trang đến kính mắt y tế, kính râm và các phụ kiện kèm theo.
              </p>
              <p className="mt-4 text-lg text-gray-500">
                Với đội ngũ chuyên viên đo mắt được đào tạo chuyên sâu và các kỹ thuật viên lành nghề, chúng tôi tự hào mang đến dịch vụ chăm sóc mắt toàn diện và sản phẩm kính mắt phù hợp với nhu cầu của từng khách hàng.
              </p>
            </div>
            <div className="mt-10 lg:mt-0">
              <div className="aspect-w-4 aspect-h-3 rounded-lg overflow-hidden">
                <Image src="/images/about/team.jpg" alt="Đội ngũ Eyewear Store" width={600} height={450} className="object-cover" />
              </div>
            </div>
          </div>
        </div>

        {/* Stats section */}
        <div className="bg-indigo-50">
          <div className="max-w-7xl mx-auto py-12 px-4 sm:px-6 lg:px-8">
            <div className="grid grid-cols-2 gap-8 md:grid-cols-4">
              <div className="text-center">
                <div className="text-4xl font-extrabold text-indigo-600">15+</div>
                <div className="mt-2 text-base font-medium text-gray-700">Năm kinh nghiệm</div>
              </div>
              <div className="text-center">
                <div className="text-4xl font-extrabold text-indigo-600">20+</div>
                <div className="mt-2 text-base font-medium text-gray-700">Cửa hàng trên toàn quốc</div>
              </div>
              <div className="text-center">
                <div className="text-4xl font-extrabold text-indigo-600">50k+</div>
                <div className="mt-2 text-base font-medium text-gray-700">Khách hàng hài lòng</div>
              </div>
              <div className="text-center">
                <div className="text-4xl font-extrabold text-indigo-600">30+</div>
                <div className="mt-2 text-base font-medium text-gray-700">Thương hiệu độc quyền</div>
              </div>
            </div>
          </div>
        </div>

        {/* Values section */}
        <div className="max-w-7xl mx-auto py-16 px-4 sm:px-6 lg:py-24 lg:px-8">
          <div className="max-w-3xl mx-auto text-center">
            <h2 className="text-3xl font-extrabold text-gray-900">Giá trị cốt lõi</h2>
            <p className="mt-4 text-lg text-gray-500">
              Tại Eyewear Store, chúng tôi hoạt động dựa trên những giá trị mang tính định hướng về chất lượng, sự chân thành và dịch vụ khách hàng.
            </p>
          </div>
          <dl className="mt-12 space-y-10 sm:space-y-0 sm:grid sm:grid-cols-3 sm:gap-8">
            <div className="text-center">
              <dt className="text-lg font-medium text-gray-900">Chất lượng hàng đầu</dt>
              <dd className="mt-2 text-base text-gray-500">
                Chúng tôi chỉ cung cấp các sản phẩm chất lượng cao từ những thương hiệu uy tín với tiêu chuẩn quốc tế.
              </dd>
            </div>
            <div className="text-center">
              <dt className="text-lg font-medium text-gray-900">Tư vấn chuyên nghiệp</dt>
              <dd className="mt-2 text-base text-gray-500">
                Đội ngũ nhân viên được đào tạo chuyên sâu, tận tâm giúp bạn lựa chọn sản phẩm phù hợp nhất.
              </dd>
            </div>
            <div className="text-center">
              <dt className="text-lg font-medium text-gray-900">Dịch vụ hậu mãi</dt>
              <dd className="mt-2 text-base text-gray-500">
                Cam kết bảo hành dài hạn và hỗ trợ khách hàng liên tục trong suốt quá trình sử dụng sản phẩm.
              </dd>
            </div>
          </dl>
        </div>

        {/* Brands section */}
        <div className="bg-gray-50">
          <div className="max-w-7xl mx-auto py-16 px-4 sm:px-6 lg:px-8">
            <h2 className="text-2xl font-extrabold text-gray-900 text-center mb-8">Các thương hiệu nổi tiếng</h2>
            <div className="grid grid-cols-2 gap-8 md:grid-cols-6 lg:grid-cols-6">
              <div className="col-span-1 flex justify-center py-8 px-8 bg-white">
                <img className="max-h-12" src="/images/brands/rayban.png" alt="Ray-Ban" />
              </div>
              <div className="col-span-1 flex justify-center py-8 px-8 bg-white">
                <img className="max-h-12" src="/images/brands/gucci.png" alt="Gucci" />
              </div>
              <div className="col-span-1 flex justify-center py-8 px-8 bg-white">
                <img className="max-h-12" src="/images/brands/oakley.png" alt="Oakley" />
              </div>
              <div className="col-span-1 flex justify-center py-8 px-8 bg-white">
                <img className="max-h-12" src="/images/brands/prada.png" alt="Prada" />
              </div>
              <div className="col-span-1 flex justify-center py-8 px-8 bg-white">
                <img className="max-h-12" src="/images/brands/dior.png" alt="Dior" />
              </div>
              <div className="col-span-1 flex justify-center py-8 px-8 bg-white">
                <img className="max-h-12" src="/images/brands/tomford.png" alt="Tom Ford" />
              </div>
            </div>
          </div>
        </div>

        {/* Team section */}
        <div className="max-w-7xl mx-auto py-16 px-4 sm:px-6 lg:py-24 lg:px-8">
          <div className="lg:grid lg:grid-cols-3 lg:gap-8">
            <div>
              <h2 className="text-3xl font-extrabold text-gray-900">Đội ngũ lãnh đạo</h2>
              <p className="mt-4 text-lg text-gray-500">
                Đội ngũ lãnh đạo của chúng tôi bao gồm những chuyên gia hàng đầu trong ngành mắt kính và bán lẻ, với niềm đam mê mang đến những sản phẩm và dịch vụ tốt nhất.
              </p>
            </div>
            <div className="mt-12 lg:mt-0 lg:col-span-2">
              <div className="space-y-12 sm:grid sm:grid-cols-2 sm:gap-x-6 sm:gap-y-12 sm:space-y-0 lg:gap-x-8">
                <div className="space-y-4">
                  <div className="aspect-w-3 aspect-h-2">
                    <Image className="object-cover rounded-lg" src="/images/about/ceo.jpg" alt="CEO" width={300} height={200} />
                  </div>
                  <div>
                    <h3 className="text-lg font-medium text-gray-900">Nguyễn Văn A</h3>
                    <p className="text-indigo-600">Tổng Giám đốc</p>
                  </div>
                </div>

                <div className="space-y-4">
                  <div className="aspect-w-3 aspect-h-2">
                    <Image className="object-cover rounded-lg" src="/images/about/cto.jpg" alt="CTO" width={300} height={200} />
                  </div>
                  <div>
                    <h3 className="text-lg font-medium text-gray-900">Trần Thị B</h3>
                    <p className="text-indigo-600">Giám đốc Công nghệ</p>
                  </div>
                </div>
              </div>
            </div>
          </div>
        </div>
      </div>
    </Layout>
  );
}
