import Mainmenu from "@/UIBlocks/Mainmenu";
import ProductCard from "@/UIBlocks/ProductCard";
import BannerCarousel from "@/UIBlocks/BannerCarousel";
import GroupProductCard from "@/UIBlocks/GroupProductCard";
import ProductCard2 from "@/UIBlocks/ProductCard2";
import AdverthismentBanner from "@/UIBlocks/Promotion/AdverthismentBanner";
import PromotionSection from "@/UIBlocks/Promotion/PromotionSection";
import ScrollAdverthisment from "@/UIBlocks/Promotion/ScrollAdverthisment";

function Home() {
  return (
    <div>
      <Mainmenu />
      <BannerCarousel
        api={`api/resource/Product?fields=["name"]&filters=[["is_slider", "=", 1]]`}
        delay={6000}
      />
      <ProductCard
        title="Popular Items"
        api={`api/resource/Product?fields=["name"]&filters=[["is_popular", "=", 1]]`}
        ribbon={true}
      />
      <div className="flex flex-col md:flex-row gap-5 px-[5%]">
        <GroupProductCard
          title={"Hot Gadgets Today"}
          api={`api/resource/Product?fields=["name"]&filters=[["top_rated", "=", 1]]`}
        />
        <GroupProductCard
          title="Discount for you"
          api={`api/resource/Product?fields=["name"]&filters=[["is_discount", "=", 1]]`}
        />
      </div>
      <AdverthismentBanner
        api={`api/resource/Product?fields=["name"]&filters=[["is_slider", "=", 1]]`}
        delay={6000}
      />
      <ProductCard
        title="Laptops"
        api={`api/resource/Product?fields=["name"]&filters=[["is_popular", "=", 1]]`}
      />

      <div className="grid grid-cols-1 lg:grid-cols-3 gap-5 px-[5%]">
        <GroupProductCard
          title={"Top Rated"}
          api={`api/resource/Product?fields=["name"]&filters=[["top_rated", "=", 1]]`}
        />
        <GroupProductCard
          title="Best Sellers"
          api={`api/resource/Product?fields=["name"]&filters=[["is_discount", "=", 1]]`}
        />
        {/* <GroupProductCard
          title="BlockBuster Deals"
          api={`api/resource/Product?fields=["name"]&filters=[["is_discount", "=", 1]]`}
          ribbon={true}
        /> */}
        <div className="flex items-center border border-ring/30 rounded-md my-10 p-1">
          <PromotionSection />
        </div>
      </div>
      <ScrollAdverthisment
        title="Featured Brands"
        api={`api/resource/Product?fields=["name"]&filters=[["is_popular", "=", 1]]`}
      />
      <ProductCard2
        title="Popular Items"
        api={`api/resource/Product?fields=["name"]&filters=[["is_popular", "=", 1]]`}
      />
      {/* <AdvertisementBanner /> */}
    </div>
  );
}

export default Home;
