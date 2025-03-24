import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:site720_client/model/aboutUsModel.dart';
import 'package:site720_client/model/addComplaintModel.dart';
import 'package:site720_client/model/changePasswordModel.dart';
import 'package:site720_client/model/client_details/client_by_id.dart';
import 'package:site720_client/model/client_details/deduction_work_model.dart';
import 'package:site720_client/model/client_details/drawings_model.dart';
import 'package:site720_client/model/client_details/extra_work.dart';
import 'package:site720_client/model/client_details/schedule_payment_model.dart';
import 'package:site720_client/model/client_details/stage_list_model.dart';
import 'package:site720_client/model/client_details/work_updation_model.dart';
import 'package:site720_client/model/client_details/gallery.dart';
import 'package:site720_client/model/client_details/get_icons.dart';
import 'package:site720_client/model/client_details/payment_list.dart';
import 'package:site720_client/model/client_details/phase_video_model.dart';
import 'package:site720_client/model/complaintListModel.dart';
import 'package:site720_client/model/contactUsModel.dart';
import 'package:site720_client/model/forceUpdateModel.dart';
import 'package:site720_client/model/homePageModel.dart';
import 'package:site720_client/model/loginModel.dart';
import 'package:site720_client/model/phoneNumberCheck.dart';
import 'package:site720_client/model/profilePageModel.dart';
import 'package:site720_client/model/projectDetailsModel.dart';
import 'package:site720_client/model/projectListModel.dart';
import 'package:site720_client/model/resetPasswordModel.dart';
import 'package:site720_client/model/sendOtpModel.dart';
import 'package:site720_client/model/serviceListModel.dart';
import 'package:site720_client/settings/config.dart';

import '../model/bhkFilterListModel.dart';
import '../model/quotationEnquiryModel.dart';
import '../model/villaProjectModel.dart';

class HttpService {
  static Dio _dio = Dio();
  static Future forceUpdate() async {
    try {
      var result = await _dio.get(Config.apiBaseUrl + "force_updation_data");
      print(result);
      ForceUpdateModel model = ForceUpdateModel.fromJson(result.data);
      return model;
    } catch (Exception) {
      return null;
    }
  }

  static Future login(phone, password, deviceToken) async {
    print(deviceToken);
    var formData = FormData.fromMap({
      'phone': phone,
      'password': password,
      'deviceToken': deviceToken,
    });
    try {
      var result = await _dio.post(Config.apiBaseUrl + "login", data: formData);
      LoginModel model = LoginModel.fromJson(result.data);
      print(result);
      return model;
    } catch (Exception) {
      return null;
    }
  }

  static Future changePassword(token, password) async {
    var formData = FormData.fromMap({
      'token': token,
      'password': password,
    });
    try {
      var result =
          await _dio.post(Config.apiBaseUrl + "resetPassword", data: formData);
      //print(params);
      print(result);

      ChangePasswordModel model = ChangePasswordModel.fromJson(result.data);

      return model;
    } catch (Exception) {
      return null;
    }
  }

  static Future addContactForm(
      name, phoneNumber, place, serviceId, message) async {
    var formData = FormData.fromMap({
      'name': name,
      'phone': phoneNumber,
      'place': place,
      'service_id': serviceId,
      'message': message,
    });
    try {
      var result = await _dio.post(Config.apiBaseUrl + "add_contact_form",
          data: formData);
      //print(params);
      print(result);

      ContactUsModel model = ContactUsModel.fromJson(result.data);

      return model;
    } catch (Exception) {
      return null;
    }
  }

  static Future addQuotationForm(
      name, phoneNumber, planImage, dImage, message) async {
    var formData = FormData.fromMap({
      'name': name,
      'phone_number': phoneNumber,
      'plan_image': await MultipartFile.fromFile(planImage!),
      '3d_plan':
          dImage == null ? dImage : await MultipartFile.fromFile(dImage!),
      'message': message,
    });
    try {
      var result =
          await _dio.post(Config.apiBaseUrl + "postEnquiry", data: formData);
      //print(params);
      print(result);
      QuotationEnquiryModel model = QuotationEnquiryModel.fromJson(result.data);
      return model;
    } catch (Exception) {
      return null;
    }
  }

  static Future getClientByID(token) async {
    print(token);
    var formData = FormData.fromMap({
      'token': token,
    });
    try {
      var result =
          await _dio.post(Config.apiBaseUrl + "getClientByID", data: formData);

      ClientByIdModel model = ClientByIdModel.fromJson(result.data);

      return model;
    } catch (Exception) {
      return null;
    }
  }

  static Future getGallery(token) async {
    print(token);
    var formData = FormData.fromMap({
      'token': token,
    });
    try {
      var result = await _dio.post(Config.apiBaseUrl + "getClientPhasesImages",
          data: formData);
      //print(params);
      print(result);

      GalleryModel model = GalleryModel.fromJson(result.data);

      return model;
    } catch (Exception) {
      return null;
    }
  }

  static Future getClientPaymentDetails(token) async {
    print(token);
    var formData = FormData.fromMap({
      'token': token,
    });
    try {
      var result = await _dio
          .post(Config.apiBaseUrl + "getClientPaymentDetails", data: formData);
      //print(params);
      print(result);

      if (result.statusCode == 200) {
        PaymentListModel model = PaymentListModel.fromJson(result.data);
        return model;
      }
    } catch (e) {
      log(e.toString());
      return null;
    }
  }

  static Future getClientScheduledPayment(token) async {
    print(token);
    var formData = FormData.fromMap({
      'token': token,
    });
    try {
      var result = await _dio.post(
          Config.apiBaseUrl + "getClientScheduledPayment",
          data: formData);
      //print(params);
      print(result);

      SchedulePaymentModel model = SchedulePaymentModel.fromJson(result.data);

      return model;
    } catch (Exception) {
      return null;
    }
  }

  static Future getStageList(token) async {
    print(token);
    var formData = FormData.fromMap({
      'token': token,
    });
    try {
      var result = await _dio.post(Config.apiBaseUrl + "getClientStages",
          data: formData);

      if (result.statusCode == 200) {
        StageListModel model = StageListModel.fromJson(result.data);
        return model;
      }
    } catch (Exception) {
      return null;
    }
  }

  static Future getClientDeductionWork(token) async {
    print(token);
    var formData = FormData.fromMap({
      'token': token,
    });
    try {
      var result = await _dio.post(Config.apiBaseUrl + "getClientDeductionWork",
          data: formData);

      if (result.statusCode == 200) {
        DeductionWorkModel model = DeductionWorkModel.fromJson(result.data);
        return model;
      }
    } catch (Exception) {
      return null;
    }
  }

  static Future getClientPhasesVideo(token) async {
    print(token);
    var formData = FormData.fromMap({
      'token': token,
    });
    try {
      var result = await _dio.post(Config.apiBaseUrl + "getClientPhasesVideo",
          data: formData);
      //print(params);
      print(result);

      PhaseVideoModel model = PhaseVideoModel.fromJson(result.data);

      return model;
    } catch (Exception) {
      return null;
    }
  }

  static Future getWorkStatus(token) async {
    print(token);
    var formData = FormData.fromMap({
      'token': token,
    });
    try {
      var result = await _dio.post(Config.apiBaseUrl + "getClientWorkUpdates",
          data: formData);
      //print(params);
      print(result);

      ClientWorkStatusModel model = ClientWorkStatusModel.fromJson(result.data);

      return model;
    } catch (Exception) {
      return null;
    }
  }

  static Future getClientExtraWork(token) async {
    print(token);
    var formData = FormData.fromMap({
      'token': token,
    });
    try {
      var result = await _dio.post(Config.apiBaseUrl + "getClientExtraWork",
          data: formData);
      print(result);

      ExtraWorkModel model = ExtraWorkModel.fromJson(result.data);

      return model;
    } catch (Exception) {
      return null;
    }
  }

  static Future getClientPackage(token) async {
    print(token);
    var formData = FormData.fromMap({
      'token': token,
    });
    try {
      var result = await _dio.post(
        Config.apiBaseUrl + "getClientPackage",
        data: formData,
        options: Options(responseType: ResponseType.bytes),
      );
      // print(result);

      // PackageModel model = PackageModel.fromJson(result.data);

      return result;
    } catch (Exception) {
      return null;
    }
  }

  static Future profile(token) async {
    print(token);
    var formData = FormData.fromMap({
      'token': token,
    });
    try {
      var result = await _dio.post(Config.apiBaseUrl + "getClientDetails",
          data: formData);
      //print(params);
      print(result);

      ProfilePageModel model = ProfilePageModel.fromJson(result.data);

      return model;
    } catch (Exception) {
      return null;
    }
  }

  static Future getClientSiteDrawings(token) async {
    print(token);
    var formData = FormData.fromMap({
      'token': token,
    });
    try {
      var result = await _dio.post(Config.apiBaseUrl + "getClientSiteDrawings",
          data: formData);
      //print(params);
      print(result);

      DrawingsModel model = DrawingsModel.fromJson(result.data);

      return model;
    } catch (Exception) {
      return null;
    }
  }

  static Future getIcons(token) async {
    print(token);
    var formData = FormData.fromMap({
      'token': token,
    });
    try {
      var result =
          await _dio.post(Config.apiBaseUrl + "getIcons", data: formData);
      //print(params);
      print(result);

      GetIconsModel model = GetIconsModel.fromJson(result.data);

      return model;
    } catch (Exception) {
      return null;
    }
  }

  static Future complaintList(token) async {
    print(token);
    var formData = FormData.fromMap({
      'token': token,
    });
    try {
      var result =
          await _dio.post(Config.apiBaseUrl + "view_complaint", data: formData);
      //print(params);
      print(result);

      ComplaintListModel model = ComplaintListModel.fromJson(result.data);

      return model;
    } catch (Exception) {
      return null;
    }
  }

  static Future addComplaint(token, complaint) async {
    print(token);
    var formData = FormData.fromMap({'token': token, 'complaint': complaint});
    try {
      var result =
          await _dio.post(Config.apiBaseUrl + "add_complaint", data: formData);
      //print(params);
      print(result);

      AddComplaintModel model = AddComplaintModel.fromJson(result.data);

      return model;
    } catch (Exception) {
      return null;
    }
  }

  static Future dashboard() async {
    print('a');
    try {
      var result = await _dio.get(Config.apiBaseUrl + "home");
      print(result);
      HomePageModel model = HomePageModel.fromJson(result.data);
      return model;
    } catch (Exception) {
      return null;
    }
  }

  static Future projectList(currentPage, itemPerPage, bhk, minAmount, maxAmount,
      minSquareFeet, maxSquareFeet) async {
    var params = {
      "currentPage": currentPage,
      "itemPerPage": itemPerPage,
      "bhk": bhk,
      "minAmount": minAmount,
      "maxAmount": maxAmount,
      "minSquareFeet": minSquareFeet,
      "maxSquareFeet": maxSquareFeet
    };
    print(params);
    try {
      var result = await _dio.get(Config.apiBaseUrl + "newdashboard",
          queryParameters: params);
      print(result);
      ProjectListModel model = ProjectListModel.fromJson(result.data);
      return model;
    } catch (Exception) {
      return null;
    }
  }

  static Future projectDetails(projectId) async {
    var formData = FormData.fromMap({
      'project_id': projectId,
    });
    try {
      var result =
          await _dio.post(Config.apiBaseUrl + "projectDetails", data: formData);
      print(result);
      ProjectDetailsModel model = ProjectDetailsModel.fromJson(result.data);

      return model;
    } catch (Exception) {
      return null;
    }
  }

  static Future aboutUs() async {
    try {
      var result = await _dio.get(Config.apiBaseUrl + "about_us");
      print(result);
      AboutUsModel model = AboutUsModel.fromJson(result.data);
      return model;
    } catch (Exception) {
      return null;
    }
  }

  static Future serviceList() async {
    print('a');
    try {
      var result = await _dio.get(Config.apiBaseUrl + "serviceList");
      print(result);
      ServiceListModel model = ServiceListModel.fromJson(result.data);
      return model;
    } catch (Exception) {
      return null;
    }
  }

  static Future phoneNumberCheck(phoneNumber) async {
    var formData = FormData.fromMap({
      'phone': phoneNumber,
    });
    try {
      var result = await _dio.post(Config.apiBaseUrl + "check_phone_number",
          data: formData);
      print(result);
      PhoneNumberCheck model = PhoneNumberCheck.fromJson(result.data);

      return model;
    } catch (Exception) {
      return null;
    }
  }

  static Future sendOtp(phoneNumber, otp) async {
    var formData = FormData.fromMap({
      'phone': phoneNumber,
      'otp': otp,
    });
    try {
      var result =
          await _dio.post(Config.apiBaseUrl + "sendOTP", data: formData);
      print(result);
      SendOtpModel model = SendOtpModel.fromJson(result.data);

      return model;
    } catch (Exception) {
      return null;
    }
  }

  static Future resetPassword(phoneNumber, password) async {
    var formData = FormData.fromMap({
      'phone': phoneNumber,
      'password': password,
    });
    try {
      var result =
          await _dio.post(Config.apiBaseUrl + "reset_password", data: formData);
      print(result);
      ResetPasswordModel model = ResetPasswordModel.fromJson(result.data);

      return model;
    } catch (Exception) {
      return null;
    }
  }

  static Future bhkFilterList() async {
    try {
      var result = await _dio.get(Config.apiBaseUrl + "getCategory");
      print(result);
      BhkFilterListModel model = BhkFilterListModel.fromJson(result.data);
      return model;
    } catch (Exception) {
      return null;
    }
  }

  static Future villaProjectList() async {
    try {
      var result = await _dio.get(Config.apiBaseUrl + "villaProjects");
      print(result);
      VillaProjectModel model = VillaProjectModel.fromJson(result.data);
      return model;
    } catch (Exception) {
      return null;
    }
  }
}
